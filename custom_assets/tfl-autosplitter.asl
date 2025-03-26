state("gk") {
  // nothing to do here; we need to grab the pointers ourselves instead of hardcoding them
}

// Runs once, the only place you can add custom settings, before the process is connected to!
startup {
  // NOTE: Enable Log Output
  Action<string, bool> DebugOutput = (text, setting) => {
    if (setting) {
      print("[OpenGOAL-Jak1] " + text);
    }
  };
  vars.DebugOutput = DebugOutput;

  Action<List<Dictionary<String, dynamic>>, string, int, Type, dynamic, bool, string, bool> AddOption = (list, id, offset, type, splitVal, defaultEnabled, name, debug) => {
    var d = new Dictionary<String, dynamic>();
    d.Add("id", id);
    d.Add("offset", offset);
    d.Add("type", type);
    d.Add("splitVal", splitVal);
    d.Add("defaultEnabled", defaultEnabled);
    d.Add("name", name);
    d.Add("debug", debug);
    list.Add(d);
  };

  Action<dynamic, string> AddToSettings = (options, parent) => {
    foreach (Dictionary<String, dynamic> option in options) {
      settings.Add(option["id"], option["defaultEnabled"], option["name"], parent);
    }
  };

  settings.Add("asl_settings", true, "Autosplitter Settings");
  settings.Add("asl_settings_debug", false, "Enable Debug Logs", "asl_settings");

  vars.optionLists = new List<List<Dictionary<String, dynamic>>>();

  // Per-level All Orbs Splits
  settings.Add("tfl_level_all_orbs", true, "All Orbs per level");
  vars.allOrbs = new List<Dictionary<String, dynamic>>();

  var jak1_need_res_offset = 424;
  var tfl_counts_offset = jak1_need_res_offset + 112;
  var tfl_money_offset = tfl_counts_offset + 12;
  var tfl_buzzer_offset = tfl_money_offset + 5;
  var tfl_res_offset = tfl_buzzer_offset + 5;
  var tfl_misc_offset = tfl_res_offset + 32;
  var LOWRESKUI_COUNT = 5;

  // money
  AddOption(vars.allOrbs, "crystalc_money", tfl_money_offset, typeof(byte), 150, false, "Crystal Cave - All Orbs", false);
  AddOption(vars.allOrbs, "crescent_money", tfl_money_offset + 1, typeof(byte), 200, false, "Crescent Top - All Orbs", false);
  AddOption(vars.allOrbs, "energybay_money", tfl_money_offset + 2, typeof(byte), 200, false, "Energy Bay - All Orbs", false);
  AddOption(vars.allOrbs, "mines_money", tfl_money_offset + 3, typeof(byte), 150, false, "Open Mines - All Orbs", false);
  AddOption(vars.allOrbs, "valley_money", tfl_money_offset + 4, typeof(byte), 50, false, "Taiga Valley - All Orbs", false);
  AddToSettings(vars.allOrbs, "tfl_level_all_orbs");
  vars.optionLists.Add(vars.allOrbs);

  // Per-level Scout Fly Splits
  Action<List<Dictionary<String, dynamic>>, string, int, string> AddScoutFlyOptions = (list, id_prefix, offset, name_prefix) => {
    for (int i = 1; i <= 7; i++) {
      AddOption(list, id_prefix + i, offset, typeof(byte), i, false, name_prefix + "Scout Fly " + i, false);
    }
  };
  settings.Add("tfl_level_scout_flies", true, "Scout Flies per level");

  // buzzer
  vars.crystalcScoutFlies = new List<Dictionary<String, dynamic>>();
  AddScoutFlyOptions(vars.crystalcScoutFlies, "crystalc_buzzer_", tfl_buzzer_offset, "Crystal Cave - ");
  settings.Add("tfl_level_scout_flies_crystalc", true, "Crystal Cave", "tfl_level_scout_flies");
  AddToSettings(vars.crystalcScoutFlies, "tfl_level_scout_flies_crystalc");
  vars.optionLists.Add(vars.crystalcScoutFlies);

  vars.crescentScoutFlies = new List<Dictionary<String, dynamic>>();
  AddScoutFlyOptions(vars.crescentScoutFlies, "crescent_buzzer_", tfl_buzzer_offset + 1, "Crescent Top - ");
  settings.Add("tfl_level_scout_flies_crescent", true, "Crescent Top", "tfl_level_scout_flies");
  AddToSettings(vars.crescentScoutFlies, "tfl_level_scout_flies_crescent");
  vars.optionLists.Add(vars.crescentScoutFlies);

  vars.energybayScoutFlies = new List<Dictionary<String, dynamic>>();
  AddScoutFlyOptions(vars.energybayScoutFlies, "energybay_buzzer_", tfl_buzzer_offset + 2, "Energy Bay - ");
  settings.Add("tfl_level_scout_flies_energybay", true, "Energy Bay", "tfl_level_scout_flies");
  AddToSettings(vars.energybayScoutFlies, "tfl_level_scout_flies_energybay");
  vars.optionLists.Add(vars.energybayScoutFlies);

  vars.minesScoutFlies = new List<Dictionary<String, dynamic>>();
  AddScoutFlyOptions(vars.minesScoutFlies, "mines_buzzer_", tfl_buzzer_offset + 3, "Open Mines - ");
  settings.Add("tfl_level_scout_flies_mines", true, "Open Mines", "tfl_level_scout_flies");
  AddToSettings(vars.minesScoutFlies, "tfl_level_scout_flies_mines");
  vars.optionLists.Add(vars.minesScoutFlies);

  vars.valleyScoutFlies = new List<Dictionary<String, dynamic>>();
  AddScoutFlyOptions(vars.valleyScoutFlies, "valley_buzzer_", tfl_buzzer_offset + 4, "Taiga Valley - ");
  settings.Add("tfl_level_scout_flies_valley", true, "Taiga Valley", "tfl_level_scout_flies");
  AddToSettings(vars.valleyScoutFlies, "tfl_level_scout_flies_valley");
  vars.optionLists.Add(vars.valleyScoutFlies);

  // lowreskui
  settings.Add("tfl_all_lowreskuis", true, "All LowResKuis");
  vars.lowreskuis = new List<Dictionary<String, dynamic>>();
  AddOption(vars.lowreskuis, "lowreskuis", tfl_misc_offset, typeof(byte), LOWRESKUI_COUNT, false, "All LowResKuis", false);
  AddToSettings(vars.lowreskuis, "tfl_all_lowreskuis");
  vars.optionLists.Add(vars.lowreskuis);

  // Need Resolution Splits (power cells) - offset is relative from the need resolution block of the struct
  settings.Add("tfl_need_res", true, "Power Cells");

  // Crystal Cave
  vars.crystalcResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.crystalcResolutions, "res_crystalc_middle", tfl_res_offset, typeof(byte), 1, false, "Reach the Middle of the Cave", false);
  AddOption(vars.crystalcResolutions, "res_crystalc_river", tfl_res_offset + 1, typeof(byte), 1, false, "Follow the River", false);
  AddOption(vars.crystalcResolutions, "res_crystalc_ship", tfl_res_offset + 2, typeof(byte), 1, false, "Climb the Precursor Ship", false);
  AddOption(vars.crystalcResolutions, "res_crystalc_shrooms", tfl_res_offset + 3, typeof(byte), 1, false, "Reach the Orange Mushrooms", false);
  AddOption(vars.crystalcResolutions, "res_crystalc_buzzer", tfl_res_offset + 4, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  AddOption(vars.crystalcResolutions, "res_crystalc_hidden", tfl_res_offset + 5, typeof(byte), 1, false, "Walk Over the Infested Ground", false);
  settings.Add("tfl_need_res_crystalc", true, "Crystal Cave", "tfl_need_res");
  AddToSettings(vars.crystalcResolutions, "tfl_need_res_crystalc");
  vars.optionLists.Add(vars.crystalcResolutions);

  // Crescent Top
  vars.crescentResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.crescentResolutions, "res_crescent_observatory", tfl_res_offset + 7, typeof(byte), 1, false, "Explore the Observatory", false);
  AddOption(vars.crescentResolutions, "res_crescent_robot", tfl_res_offset + 8, typeof(byte), 1, false, "Climb the Precursor Robot", false);
  AddOption(vars.crescentResolutions, "res_crescent_lava", tfl_res_offset + 9, typeof(byte), 1, false, "Jump Over the Lava Pool", false);
  AddOption(vars.crescentResolutions, "res_crescent_zoomer", tfl_res_offset + 10, typeof(byte), 1, false, "Jump Over the Platforms With the Zoomer", false);
  AddOption(vars.crescentResolutions, "res_crescent_orange_ring", tfl_res_offset + 11, typeof(byte), 1, false, "Beat the Orange Rings", false);
  AddOption(vars.crescentResolutions, "res_crescent_buzzer", tfl_res_offset + 12, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  settings.Add("tfl_need_res_crescent", true, "Crescent Top", "tfl_need_res");
  AddToSettings(vars.crescentResolutions, "tfl_need_res_crescent");
  vars.optionLists.Add(vars.crescentResolutions);

  // Energy Bay
  vars.energybayResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.energybayResolutions, "res_energybay_turbine1", tfl_res_offset + 13, typeof(byte), 1, false, "Activate the 1st Turbine", false);
  AddOption(vars.energybayResolutions, "res_energybay_turbine2", tfl_res_offset + 14, typeof(byte), 1, false, "Activate the 2nd Turbine", false);
  AddOption(vars.energybayResolutions, "res_energybay_turbine3", tfl_res_offset + 15, typeof(byte), 1, false, "Activate the 3rd Turbine", false);
  AddOption(vars.energybayResolutions, "res_energybay_turbine4", tfl_res_offset + 16, typeof(byte), 1, false, "Activate the 4th Turbine", false);
  AddOption(vars.energybayResolutions, "res_energybay_kill", tfl_res_offset + 17, typeof(byte), 1, false, "Break the Balloon Lurkers", false);
  AddOption(vars.energybayResolutions, "res_energybay_green_ring", tfl_res_offset + 18, typeof(byte), 1, false, "Beat the Green Rings", false);
  AddOption(vars.energybayResolutions, "res_energybay_buzzer", tfl_res_offset + 19, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  settings.Add("tfl_need_res_energybay", true, "Energy Bay", "tfl_need_res");
  AddToSettings(vars.energybayResolutions, "tfl_need_res_energybay");
  vars.optionLists.Add(vars.energybayResolutions);

  // Open Mines
  vars.minesResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.minesResolutions, "res_mines_drop_plat", tfl_res_offset + 20, typeof(byte), 1, false, "Jump Over the Dropping Platforms", false);
  AddOption(vars.minesResolutions, "res_mines_kegs", tfl_res_offset + 21, typeof(byte), 1, false, "Survive the Keg Labyrinth", false);
  AddOption(vars.minesResolutions, "res_mines_minecarts", tfl_res_offset + 22, typeof(byte), 1, false, "Follow the Minecarts", false);
  AddOption(vars.minesResolutions, "res_mines_ambush", tfl_res_offset + 23, typeof(byte), 1, false, "Beat the Ambush", false);
  AddOption(vars.minesResolutions, "res_mines_excavator", tfl_res_offset + 24, typeof(byte), 1, false, "Activate the Excavator", false);
  AddOption(vars.minesResolutions, "res_mines_hole", tfl_res_offset + 25, typeof(byte), 1, false, "Explore the Opening", false);
  AddOption(vars.minesResolutions, "res_mines_buzzer", tfl_res_offset + 26, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  settings.Add("tfl_need_res_mines", true, "Open Mines", "tfl_need_res");
  AddToSettings(vars.minesResolutions, "tfl_need_res_mines");
  vars.optionLists.Add(vars.minesResolutions);

  // Taiga Valley
  vars.valleyResolutions = new List<Dictionary<String, dynamic>>();
  AddOption(vars.valleyResolutions, "res_valley_end", tfl_res_offset + 27, typeof(byte), 1, false, "Reach the End of the Valley", false);
  AddOption(vars.valleyResolutions, "res_valley_hidden", tfl_res_offset + 28, typeof(byte), 1, false, "Find the Hidden Cell", false);
  AddOption(vars.valleyResolutions, "res_valley_kill", tfl_res_offset + 29, typeof(byte), 1, false, "Catch All the Flying Lurkers", false);
  AddOption(vars.valleyResolutions, "res_valley_boss", tfl_res_offset + 30, typeof(byte), 1, false, "Neutralize the Defense System", false);
  AddOption(vars.valleyResolutions, "res_valley_buzzer", tfl_res_offset + 31, typeof(byte), 1, false, "Free 7 Scout Flies", false);
  settings.Add("tfl_need_res_valley", true, "Taiga Valley", "tfl_need_res");
  AddToSettings(vars.valleyResolutions, "tfl_need_res_valley");
  vars.optionLists.Add(vars.valleyResolutions);

  // Misc Tasks
  // - other tasks other than `need_resolution` ones, the ones deemed useful enough to be added
  settings.Add("tfl_misc_tasks", true, "Misc Tasks");
  vars.tflMiscallenousTasks = new List<Dictionary<String, dynamic>>();
  AddOption(vars.tflMiscallenousTasks, "res_crystalc_gondola", tfl_res_offset + 6, typeof(byte), 1, false, "Activated the Gondola", false);
  AddOption(vars.tflMiscallenousTasks, "tfl_energy_bay_launcher", tfl_misc_offset + 3, typeof(byte), 1, true, "Used Energy Bay Launcher", false);
  AddOption(vars.tflMiscallenousTasks, "tfl_valley_rock", tfl_misc_offset + 2, typeof(byte), 1, true, "Destroyed Valley Rock", false);
  AddOption(vars.tflMiscallenousTasks, "tfl_lab_door_opened", tfl_misc_offset + 1, typeof(byte), 1, true, "Open Taiga Valley Door", false);
  AddToSettings(vars.tflMiscallenousTasks, "tfl_misc_tasks");
  vars.optionLists.Add(vars.tflMiscallenousTasks);

  // Treat this one as special, so we can ensure the timer ends no matter what!
  // vars.finalSplitTask = vars.tflMiscallenousTasks[3];

  vars.DebugOutput("Finished {startup}", true);
}

init {
  vars.DebugOutput("Running {init} looking for `gk.exe`", true);
  var sw = new Stopwatch();
  sw.Start();
  var exported_ptr = IntPtr.Zero;
  vars.foundPointers = false;
  byte[] marker = Encoding.ASCII.GetBytes("UnLiStEdStRaTs_JaK1" + Char.MinValue);
  vars.debugTick = 0;
  // NOTE - the subtraction is a total hack.  When we switched to SDL the statically linked binary now has this new `No Access` region of 0x1000 bytes near the end of the first module
  // This feels like a total hack and is brittle (memory layout can change in the future, sizes can change, new regions can be added).
  //
  // 28672 = 0x7000 and this is the size from the end of the first module to before the beginning of this No Access region at the time of writing.
  //
  // However, since this is a hack, we should probably be a bit more conservative incase more the region layout changes.
  //
  // LiveSplit tries to read the entire region it's given into memory and a partial read is a failure.
  vars.DebugOutput(String.Format("Scanning First Module - {0}->{1}", modules.First().BaseAddress.ToString("x8"), (modules.First().BaseAddress.ToInt64() + modules.First().ModuleMemorySize - 100000).ToString("x8")), true);
  exported_ptr = new SignatureScanner(game, modules.First().BaseAddress, modules.First().ModuleMemorySize - 200000).Scan(
    new SigScanTarget(marker.Length, marker)
  );

  if (exported_ptr == IntPtr.Zero) {
    vars.DebugOutput("Could not find the AutoSplittingInfo struct, old version of gk.exe? Failing!", true);
    sw.Reset();
    return false;
  }
  vars.DebugOutput(String.Format("Found AutoSplittingInfo struct - {0}", exported_ptr.ToString("x8")), true);

  // The offset to the GOAL struct is stored in a u64 next to the marker!
  var goal_struct_ptr = new IntPtr(memory.ReadValue<long>(exported_ptr + 4));
  while (goal_struct_ptr == IntPtr.Zero) {
    vars.DebugOutput("Could not find pointer to GOAL struct, game still loading? Retrying in 1000ms...!", true);
    Thread.Sleep(1000);
    sw.Reset();
    throw new Exception("Could not find pointer to GOAL struct, game still loading? Retrying...");
  }
  Action<MemoryWatcherList, IntPtr, List<Dictionary<String, dynamic>>> AddMemoryWatchers = (memList, bPtr, options) => {
    foreach (Dictionary<String, dynamic> option in options) {
      var finalOffset = bPtr + (option["offset"]);
      // TODO - use the type on the object to make this value properly.  Right now everything is a u8
      memList.Add(new MemoryWatcher<byte>(finalOffset) { Name = option["id"] });
      if (option["debug"] == true) {
        memList[option["id"]].Update(game);
        vars.DebugOutput(String.Format("Debug ({0}) -> ptr [{1}]; val [{2}]", option["id"], finalOffset.ToString("x8"), memList[option["id"]].Current), true);
      }
    }
  };

  var watchers = new MemoryWatcherList{
    new MemoryWatcher<uint>(goal_struct_ptr + 212) { Name = "currentGameHash" }
  };

  // Init current game has in case script is loaded while game is already started
  watchers["currentGameHash"].Update(game);

  var jak1_need_res_bptr = goal_struct_ptr; // bytes
  foreach (List<Dictionary<String, dynamic>> optionList in vars.optionLists) {
    AddMemoryWatchers(watchers, jak1_need_res_bptr, optionList);
  }
  vars.foundPointers = true;
  vars.watchers = watchers;
  sw.Stop();
  vars.DebugOutput("Script Initialized, Game Compatible.", true);
  vars.DebugOutput(String.Format("Found the exported struct at {0}", goal_struct_ptr.ToString("x8")), true);
  vars.DebugOutput(String.Format("It took {0} ms", sw.ElapsedMilliseconds), true);
}

update {
  if (!vars.foundPointers) {
    return false;
  }

  vars.watchers.UpdateAll(game);
}

reset {
  if (vars.watchers["currentGameHash"].Current != 0 && vars.watchers["currentGameHash"].Current != vars.watchers["currentGameHash"].Old) {
    vars.DebugOutput("Resetting!", settings["asl_settings_debug"]);
    vars.DebugOutput(String.Format("Reset -> Old: {0}, Curr: {1}", vars.watchers["currentGameHash"].Old, vars.watchers["currentGameHash"].Current), settings["asl_settings_debug"]);
    return true;
  }
  return false;
}

start {
  if (vars.watchers["currentGameHash"].Current != 0 && vars.watchers["currentGameHash"].Current != vars.watchers["currentGameHash"].Old) {
    vars.DebugOutput("Starting!", settings["asl_settings_debug"]);
    vars.DebugOutput(String.Format("Start -> Old: {0}, Curr: {1}", vars.watchers["currentGameHash"].Old, vars.watchers["currentGameHash"].Current), settings["asl_settings_debug"]);
    return true;
  }
  return false;
}

isLoading {
  // todo
  return false;
}

split {
  Func<List<Dictionary<String, dynamic>>, bool> InspectValues = (list) => {
    var debugThisIter = false;
    if (vars.debugTick++ % 60 == 0) {
      debugThisIter = true;
    }
    foreach (Dictionary<String, dynamic> option in list) {
      var watcher = vars.watchers[option["id"]];
      if (option["debug"] && debugThisIter) {
        vars.DebugOutput(String.Format("Debug ({0}) -> old [{1}]; current [{2}]", option["id"], watcher.Old, watcher.Current), settings["asl_settings_debug"]);
      }
      if (settings[option["id"]]) {
        // if we don't care about the amount, split on any change
        if (option["splitVal"] == null && watcher.Current != watcher.Old) {
          return true;
        }
        // Else, make sure we've hit that goal amount
        else if (option["splitVal"] != null && watcher.Current != watcher.Old && watcher.Current == option["splitVal"]) {
          return true;
        }
      }
    }
    return false;
  };
  foreach (List<Dictionary<String, dynamic>> optionList in vars.optionLists) {
    if (InspectValues(optionList)) {
      return true;
    }
  }

  // ALWAYS split if the final split condition is true, so no matter what we exhaust all splits until the end
  // if (vars.watchers[vars.finalSplitTask["id"]].Current == vars.finalSplitTask["splitVal"]) {
  //   return true;
  // }
}
