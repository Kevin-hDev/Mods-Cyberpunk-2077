// The mod's file on disk, through RedFileSystem when it is installed: <game>\r6\storages\ModSettingsNavigator\.
// RedFileSystem cannot rename a file, so there is no "temporary file, then rename": the state is written in turn to two
// files, state-a.txt and state-b.txt, each with a sequence number, and the newest whole one is read. A write cut halfway
// only spoils the older file. Format, version 1:
//   ModSettingsNavigator 1
//   sequence 12
//   <lines of Choices.reds>
//   end
// Without RedFileSystem the same class compiles with nothing inside: nothing is read or written.

@if(ModuleExists("RedFileSystem"))
import RedFileSystem.*

public func ModSettingsNavigatorFileVersion() -> Int32 {
  return 1;
}

// Far above the file's real size (two lists of 256 short lines at most): a file edited by hand or damaged cannot fill
// the memory. Past them a line, or the whole file, is refused and the log says so.
public func ModSettingsNavigatorMaxLineLength() -> Int32 {
  return 512;
}

public func ModSettingsNavigatorMaxFileLines() -> Int32 {
  return 2048;
}

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware") && ModuleExists("RedFileSystem"))
public class ModSettingsNavigatorStorage extends IScriptable {
  private let storage: ref<FileSystemStorage>;
  // The sequence of the newest whole file, and the file to write next: the other one.
  private let sequence: Int32;
  private let nextFile: String;

  // Asked once per launch of the game: RedFileSystem locks a storage asked for twice until the next launch (its
  // README).
  public func Open() -> Bool {
    this.nextFile = "state-a.txt";
    this.storage = FileSystem.GetStorage("ModSettingsNavigator");
    if !IsDefined(this.storage) {
      ModSettingsNavigatorLog("storage stopped reason=no_storage");
      return false;
    }
    return true;
  }

  public func IsOn() -> Bool {
    return IsDefined(this.storage);
  }

  // The lines between the sequence and "end" of the newest whole file; none when there is no file yet.
  public func Load() -> array<String> {
    let bodyA: array<String>;
    let bodyB: array<String>;
    let a = this.ReadFile("state-a.txt", bodyA);
    let b = this.ReadFile("state-b.txt", bodyB);
    if a < 0 && b < 0 {
      ModSettingsNavigatorLog("storage read file=none");
      return bodyA;
    }
    if a >= b {
      this.sequence = a;
      this.nextFile = "state-b.txt";
      ModSettingsNavigatorLog("storage read file=state-a.txt sequence=" + ToString(a) + " lines="
        + ToString(ArraySize(bodyA)));
      return bodyA;
    }
    this.sequence = b;
    this.nextFile = "state-a.txt";
    ModSettingsNavigatorLog("storage read file=state-b.txt sequence=" + ToString(b) + " lines="
      + ToString(ArraySize(bodyB)));
    return bodyB;
  }

  // Returns the file's sequence, or -1 when it is missing, cut or unreadable.
  private func ReadFile(name: String, out body: array<String>) -> Int32 {
    let storage = this.storage;
    if !IsDefined(storage) {
      return -1;
    }
    let status = storage.Exists(name);
    if !Equals(status, FileSystemStatus.True) {
      if !Equals(status, FileSystemStatus.False) {
        ModSettingsNavigatorLog("storage file refused file=" + name + " reason=" + ToString(status));
      }
      return -1;
    }
    let file = storage.GetFile(name);
    if !IsDefined(file) {
      ModSettingsNavigatorLog("storage file refused file=" + name + " reason=no_file");
      return -1;
    }
    let lines = file.ReadAsLines();
    let count = ArraySize(lines);
    if count < 3 || count > ModSettingsNavigatorMaxFileLines() {
      ModSettingsNavigatorLog("storage file refused file=" + name + " reason=size lines=" + ToString(count));
      return -1;
    }
    let word: String;
    let value: String;
    // A version above 1 was written by a later version of the mod: its known lines are read all the same. The first
    // word may follow a byte order mark an editor put there.
    if !StrSplitFirst(this.Clean(lines[0]), " ", word, value) || !StrEndsWith(word, "ModSettingsNavigator")
      || StringToInt(value, 0) < 1 {
      ModSettingsNavigatorLog("storage file refused file=" + name + " reason=header");
      return -1;
    }
    let sequence = -1;
    if StrSplitFirst(this.Clean(lines[1]), " ", word, value) && Equals(word, "sequence") {
      sequence = StringToInt(value, -1);
    }
    if sequence < 0 {
      ModSettingsNavigatorLog("storage file refused file=" + name + " reason=sequence");
      return -1;
    }
    // A file saved by hand may end with empty lines, or with spaces after "end".
    let last = count - 1;
    while last > 2 && StrLen(this.Trim(lines[last])) == 0 {
      last -= 1;
    }
    if !Equals(this.Trim(lines[last]), "end") {
      ModSettingsNavigatorLog("storage file refused file=" + name + " reason=cut");
      return -1;
    }
    let refused = 0;
    let i = 2;
    while i < last {
      let line = this.Clean(lines[i]);
      if StrLen(line) <= ModSettingsNavigatorMaxLineLength() {
        ArrayPush(body, line);
      } else {
        refused += 1;
      }
      i += 1;
    }
    if refused > 0 {
      ModSettingsNavigatorLog("storage lines refused file=" + name + " reason=too_long count=" + ToString(refused));
    }
    return sequence;
  }

  // A file saved by hand in a Windows editor ends its lines with a carriage return.
  private func Clean(line: String) -> String {
    return StrReplaceAll(line, "\r", "");
  }

  // Without the spaces and tabs at its end; a line longer than the bound keeps what is past it.
  private func Trim(line: String) -> String {
    let text = this.Clean(line);
    let removed = 0;
    while removed < ModSettingsNavigatorMaxLineLength() && (StrEndsWith(text, " ") || StrEndsWith(text, "\t")) {
      text = StrLeft(text, StrLen(text) - 1);
      removed += 1;
    }
    return text;
  }

  // Writes the lines in the older file, with the next sequence. When nothing could be written the log says so; the
  // memory of this launch stays right either way.
  public func Save(body: array<String>) {
    let storage = this.storage;
    if !IsDefined(storage) {
      return;
    }
    let lines: array<String>;
    ArrayPush(lines, "ModSettingsNavigator " + ToString(ModSettingsNavigatorFileVersion()));
    ArrayPush(lines, "sequence " + ToString(this.sequence + 1));
    let refused = 0;
    for line in body {
      if StrLen(line) <= ModSettingsNavigatorMaxLineLength() && !StrContains(line, "\n") && !StrContains(line, "\r") {
        ArrayPush(lines, line);
      } else {
        refused += 1;
      }
    }
    ArrayPush(lines, "end");
    let name = this.nextFile;
    let file = storage.GetFile(name);
    if !IsDefined(file) || !file.WriteLines(lines) {
      ModSettingsNavigatorLog("storage write failed file=" + name);
      return;
    }
    this.sequence += 1;
    this.nextFile = Equals(name, "state-a.txt") ? "state-b.txt" : "state-a.txt";
    ModSettingsNavigatorLog("storage written file=" + name + " sequence=" + ToString(this.sequence) + " lines="
      + ToString(ArraySize(lines) - 3) + " refused=" + ToString(refused));
  }
}

@if(ModuleExists("ModSettingsModule") && ModuleExists("Codeware") && !ModuleExists("RedFileSystem"))
public class ModSettingsNavigatorStorage extends IScriptable {
  public func Open() -> Bool {
    ModSettingsNavigatorLog("storage absent reason=no_redfilesystem");
    return false;
  }

  public func IsOn() -> Bool {
    return false;
  }

  public func Load() -> array<String> {
    let none: array<String>;
    return none;
  }

  public func Save(body: array<String>) {}
}
