gg_cam_Camera_001 = nil
gg_cam_Camera_002 = nil
gg_trg_Untitled_Trigger_001 = nil
function InitGlobals()
end

function CreateCameras()
gg_cam_Camera_001 = CreateCameraSetup()
CameraSetupSetField(gg_cam_Camera_001, CAMERA_FIELD_ZOFFSET, 0.0, 0.0)
CameraSetupSetField(gg_cam_Camera_001, CAMERA_FIELD_ROTATION, 90.0, 0.0)
CameraSetupSetField(gg_cam_Camera_001, CAMERA_FIELD_ANGLE_OF_ATTACK, 304.0, 0.0)
CameraSetupSetField(gg_cam_Camera_001, CAMERA_FIELD_TARGET_DISTANCE, 3000.0, 0.0)
CameraSetupSetField(gg_cam_Camera_001, CAMERA_FIELD_ROLL, 0.0, 0.0)
CameraSetupSetField(gg_cam_Camera_001, CAMERA_FIELD_FIELD_OF_VIEW, 70.0, 0.0)
CameraSetupSetField(gg_cam_Camera_001, CAMERA_FIELD_FARZ, 5000.0, 0.0)
CameraSetupSetField(gg_cam_Camera_001, CAMERA_FIELD_NEARZ, 16.0, 0.0)
CameraSetupSetField(gg_cam_Camera_001, CAMERA_FIELD_LOCAL_PITCH, 0.0, 0.0)
CameraSetupSetField(gg_cam_Camera_001, CAMERA_FIELD_LOCAL_YAW, 0.0, 0.0)
CameraSetupSetField(gg_cam_Camera_001, CAMERA_FIELD_LOCAL_ROLL, 0.0, 0.0)
CameraSetupSetDestPosition(gg_cam_Camera_001, 1149.4, -39.0, 0.0)
gg_cam_Camera_002 = CreateCameraSetup()
CameraSetupSetField(gg_cam_Camera_002, CAMERA_FIELD_ZOFFSET, 0.0, 0.0)
CameraSetupSetField(gg_cam_Camera_002, CAMERA_FIELD_ROTATION, 90.0, 0.0)
CameraSetupSetField(gg_cam_Camera_002, CAMERA_FIELD_ANGLE_OF_ATTACK, 304.0, 0.0)
CameraSetupSetField(gg_cam_Camera_002, CAMERA_FIELD_TARGET_DISTANCE, 1399.5, 0.0)
CameraSetupSetField(gg_cam_Camera_002, CAMERA_FIELD_ROLL, 0.0, 0.0)
CameraSetupSetField(gg_cam_Camera_002, CAMERA_FIELD_FIELD_OF_VIEW, 70.0, 0.0)
CameraSetupSetField(gg_cam_Camera_002, CAMERA_FIELD_FARZ, 5000.0, 0.0)
CameraSetupSetField(gg_cam_Camera_002, CAMERA_FIELD_NEARZ, 16.0, 0.0)
CameraSetupSetField(gg_cam_Camera_002, CAMERA_FIELD_LOCAL_PITCH, 0.0, 0.0)
CameraSetupSetField(gg_cam_Camera_002, CAMERA_FIELD_LOCAL_YAW, 0.0, 0.0)
CameraSetupSetField(gg_cam_Camera_002, CAMERA_FIELD_LOCAL_ROLL, 0.0, 0.0)
CameraSetupSetDestPosition(gg_cam_Camera_002, 1149.4, -39.0, 0.0)
end

--CUSTOM_CODE
do; local _, codeLoc = pcall(error, "", 2) --get line number where DebugUtils begins.
    --[[
     -------------------------
     -- | Debug Utils 2.3 | --
     -------------------------

     --> https://www.hiveworkshop.com/threads/lua-debug-utils-incl-ingame-console.353720/

     - by Eikonium, with special thanks to:
        - @Bribe, for pretty table print, showing that xpcall's message handler executes before the stack unwinds and useful suggestions like name caching and stack trace improvements.
        - @Jampion, for useful suggestions like print caching and applying Debug.try to all code entry points
        - @Luashine, for useful feedback and building "WC3 Debug Console Paste Helper​" (https://github.com/Luashine/wc3-debug-console-paste-helper#readme)
        - @HerlySQR, for showing a way to get a stack trace in Wc3 (https://www.hiveworkshop.com/threads/lua-getstacktrace.340841/)
        - @Macadamia, for showing a way to print warnings upon accessing nil globals, where this all started with (https://www.hiveworkshop.com/threads/lua-very-simply-trick-to-help-lua-users-track-syntax-errors.326266/)

    -----------------------------------------------------------------------------------------------------------------------------
    | Provides debugging utility for Wc3-maps using Lua.                                                                        |
    |                                                                                                                           |
    | Including:                                                                                                                |
    |   1. Automatic ingame error messages upon running erroneous code from triggers or timers.                                 |
    |   2. Ingame Console that allows you to execute code via Wc3 ingame chat.                                                  |
    |   3. Automatic warnings upon reading nil globals (which also triggers after misspelling globals)                   |
    |   4. Debug-Library functions for manual error handling.                                                                   |
    |   5. Caching of loading screen print messages until game start (which simplifies error handling during loading screen)    |
    |   6. Overwritten tostring/print-functions to show the actual string-name of an object instead of the memory position.     |
    |   7. Conversion of war3map.lua-error messages to local file error messages.                                               |
    |   8. Other useful debug utility (table.print and Debug.wc3Type)                                                           |
    -----------------------------------------------------------------------------------------------------------------------------

    -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    | Installation:                                                                                                                                                             |
    |                                                                                                                                                                           |
    |   1. Copy the code (DebugUtils.lua, StringWidth.lua and IngameConsole.lua) into your map. Use script files (Ctrl+U) in your trigger editor, not text-based triggers!      |
    |   2. Order the files: DebugUtils above StringWidth above IngameConsole. Make sure they are above ALL other scripts (crucial for local line number feature).               |
    |   3. Adjust the settings in the settings-section further below to receive the debug environment that fits your needs.                                                     |
    |                                                                                                                                                                           |
    | Deinstallation:                                                                                                                                                           |
    |                                                                                                                                                                           |
    |  - Debug Utils is meant to provide debugging utility and as such, shall be removed or invalidated from the map closely before release.                                    |
    |  - Optimally delete the whole Debug library. If that isn't suitable (because you have used library functions at too many places), you can instead replace Debug Utils     |
    |    by the following line of code that will invalidate all Debug functionality (without breaking your code):                                                               |
    |    Debug = setmetatable({try = function(...) return select(2,pcall(...)) end}, {__index = function(t,k) return DoNothing end}); try = Debug.try                           |
    |  - If that is also not suitable for you (because your systems rely on the Debug functionality to some degree), at least set ALLOW_INGAME_CODE_EXECUTION to false.         |
    |  - Be sure to test your map thoroughly after removing Debug Utils.                                                                                                        |
    -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    * Documentation and API-Functions:
    *
    *       - All automatic functionality provided by Debug Utils can be deactivated using the settings directly below the documentation.
    *
    * -------------------------
    * | Ingame Code Execution |
    * -------------------------
    *       - Debug Utils provides the ability to run code via chat command from within Wc3, if you have conducted step 3 from the installation section.
    *       - You can either open the ingame console by typing "-console" into the chat, or directly execute code by typing "-exec <code>".
    *       - See IngameConsole script for further documentation.
    *
    * ------------------
    * | Error Handling |
    * ------------------
    *        - Debug Utils automatically applies error handling (i.e. Debug.try) to code executed by your triggers and timers (error handling means that error messages are printed on screen, if anything doesn't run properly).
    *        - You can still use the below library functions for manual debugging.
    *
    *    Debug.try(funcToExecute, ...) -> ...
    *        - Help function for debugging another function (funcToExecute) that prints error messages on screen, if funcToExecute fails to execute.
    *        - DebugUtils will automatically apply this to all code run by your triggers and timers, so you rarely need to apply this manually (maybe on code run in the Lua root).
    *        - Calls funcToExecute with the specified parameters (...) in protected mode (which means that following code will continue to run even if funcToExecute fails to execute).
    *        - If the call is successful, returns the specified function's original return values (so p1 = Debug.try(Player, 0) will work fine).
    *        - If the call is unsuccessful, prints an error message on screen (including stack trace and parameters you have potentially logged before the error occured)
    *        - By default, the error message consists of a line-reference to war3map.lua (which you can look into by forcing a syntax error in WE or by exporting it from your map via File -> Export Script).
    *          You can get more helpful references to local script files instead, see section about "Local script references".
    *        - Example: Assume you have a code line like "func(param1,param2)", which doesn't work and you want to know why.
    *           Option 1: Change it to "Debug.try(func, param1, param2)", i.e. separate the function from the parameters.
    *           Option 2: Change it to "Debug.try(function() return func(param1, param2) end)", i.e. pack it into an anonymous function (optionally skip the return statement).
    *    Debug.log(...)
    *        - Logs the specified parameters to the Debug-log. The Debug-log will be printed upon the next error being catched by Debug.try, Debug.assert or Debug.throwError.
    *        - The Debug-log will only hold one set of parameters per code-location. That means, if you call Debug.log() inside any function, only the params saved within the latest call of that function will be kept.
    *    Debug.first()
    *        - Re-prints the very first error on screen that was thrown during map runtime and prevents further error messages and nil-warnings from being printed afterwards.
    *        - Useful, if a constant stream of error messages hinders you from reading any of them.
    *        - IngameConsole will still output error messages afterwards for code executed in it.
    *    Debug.throwError(...)
    *        - Prints an error message including document, line number, stack trace, previously logged parameters and all specified parameters on screen. Parameters can have any type.
    *        - In contrast to Lua's native error function, this can be called outside of protected mode and doesn't halt code execution.
    *    Debug.assert(condition:boolean, errorMsg:string, ...) -> ...
    *        - Prints the specified error message including document, line number, stack trace and previously logged parameters on screen, IF the specified condition fails (i.e. resolves to false/nil).
    *        - Returns ..., IF the specified condition holds.
    *        - This works exactly like Lua's native assert, except that it also works outside of protected mode and does not halt code execution.
    *    Debug.traceback() -> string
    *        - Returns the stack trace at the position where this is called. You need to manually print it.
    *    Debug.getLine([depth: integer]) -> integer?
    *        - Returns the line in war3map.lua, where this function is executed.
    *        - You can specify a depth d >= 1 to instead return the line, where the d-th function in the stack trace was called. I.e. depth = 2 will return the line of execution of the function that calls Debug.getLine.
    *        - Due to Wc3's limited stack trace ability, this might sometimes return nil for depth >= 3, so better apply nil-checks on the result.
    *    Debug.getLocalErrorMsg(errorMsg:string) -> string
    *        - Takes an error message containing a file and a linenumber and converts war3map.lua-lines to local document lines as defined by uses of Debug.beginFile() and Debug.endFile().
    *        - Error Msg must be formatted like "<document>:<linenumber><Rest>".
    *
    * ----------------------------
    * | Warnings for nil-globals |
    * ----------------------------
    *        - DebugUtils will print warnings on screen, if you read any global variable in your code that contains nil.
    *        - This feature is meant to spot any case where you forgot to initialize a variable with a value or misspelled a variable or function name, such as calling CraeteUnit instead of CreateUnit.
    *        - By default, warnings are disabled for globals that have been initialized with any value (including nil). I.e. you can disable nil-warnings by explicitly setting MyGlobalVariable = nil. This behaviour can be changed in the settings.
    *
    *    Debug.disableNilWarningsFor(variableName:string)
    *        - Manually disables nil-warnings for the specified global variable.
    *        - Variable must be inputted as string, e.g. Debug.disableNilWarningsFor("MyGlobalVariable").
    *
    * -----------------
    * | Print Caching |
    * -----------------
    *        - DebugUtils caches print()-calls occuring during loading screen and delays them to after game start.
    *        - This also applies to loading screen error messages, so you can wrap erroneous parts of your Lua root in Debug.try-blocks and see the message after game start.
    *
    * -------------------------
    * | Local File Stacktrace |
    * -------------------------
    *        - By default, error messages and stack traces printed by the error handling functionality of Debug Utils contain references to war3map.lua (a big file just appending all your local scripts).
    *        - The Debug-library provides the two functions below to index your local scripts, activating local file names and line numbers (matching those in your IDE) instead of the war3map.lua ones.
    *        - This allows you to inspect errors within your IDE (VSCode) instead of the World Editor.
    *
    *    Debug.beginFile(fileName: string [, depth: integer])
    *        - Tells the Debug library that the specified file begins exactly here (i.e. in the line, where this is called).
    *        - Using this improves stack traces of error messages. "war3map.lua"-references between <here> and the next Debug.endFile() will be converted to file-specific references.
    *        - All war3map.lua-lines located between the call of Debug.beginFile(fileName) and the next call of Debug.beginFile OR Debug.endFile are treated to be part of "fileName".
    *        - !!! To be called in the Lua root in Line 1 of every document you wish to track. Line 1 means exactly line 1, before any comment! This way, the line shown in the trace will exactly match your IDE.
    *        - Depth can be ignored, except if you want to use a custom wrapper around Debug.beginFile(), in which case you need to set the depth parameter to 1 to record the line of the wrapper instead of the line of Debug.beginFile().
    *    Debug.endFile([depth: integer])
    *        - Ends the current file that was previously begun by using Debug.beginFile(). War3map.lua-lines after this will not be converted until the next instance of Debug.beginFile().
    *        - The next call of Debug.beginFile() will also end the previous one, so using Debug.endFile() is optional. Mainly recommended to use, if you prefer to have war3map.lua-references in a certain part of your script (such as within GUI triggers).
    *        - Depth can be ignored, except if you want to use a custom wrapper around Debug.endFile(), you need to increase the depth parameter to 1 to record the line of the wrapper instead of the line of Debug.endFile().
    *
    * ----------------
    * | Name Caching |
    * ----------------
    *        - DebugUtils overwrites the tostring-function so that it prints the name of a non-primitive object (if available) instead of its memory position. The same applies to print().
    *        - For instance, print(CreateUnit) will show "function: CreateUnit" on screen instead of "function: 0063A698".
    *        - The table holding all those names is referred to as "Name Cache".
    *        - All names of objects in global scope will automatically be added to the Name Cache both within Lua root and again at game start (to get names for overwritten natives and your own objects).
    *        - New names entering global scope will also automatically be added, even after game start. The same applies to subtables of _G up to a depth of Debug.settings.NAME_CACHE_DEPTH.
    *        - Objects within subtables will be named after their parent tables and keys. For instance, the name of the function within T = {{bla = function() end}} is "T[1].bla".
    *        - The automatic adding doesn't work for objects saved into existing variables/keys after game start (because it's based on __newindex metamethod which simply doesn't trigger)
    *        - You can manually add names to the name cache by using the following API-functions:
    *
    *    Debug.registerName(whichObject:any, name:string)
    *        - Adds the specified object under the specified name to the name cache, letting tostring and print output "<type>: <name>" going foward.
    *        - The object must be non-primitive, i.e. this won't work on strings, numbers and booleans.
    *        - This will overwrite existing names for the specified object with the specified name.
    *    Debug.registerNamesFrom(parentTable:table [, parentTableName:string] [, depth])
    *        - Adds names for all values from within the specified parentTable to the name cache.
    *        - Names for entries will be like "<parentTableName>.<key>" or "<parentTableName>[<key>]" (depending on the key type), using the existing name of the parentTable from the name cache.
    *        - You can optionally specify a parentTableName to use that for the entry naming instead of the existing name. Doing so will also register that name for the parentTable, if it doesn't already has one.
    *        - Specifying the empty string as parentTableName will suppress it in the naming and just register all values as "<key>". Note that only string keys will be considered this way.
    *        - In contrast to Debug.registerName(), this function will NOT overwrite existing names, but just add names for new objects.
    *    Debug.oldTostring(object:any) -> string
    *        - The old tostring-function in case you still need outputs like "function: 0063A698".
    *
    * -----------------
    * | Other Utility |
    * -----------------
    *
    *    Debug.wc3Type(object:any) -> string
    *        - Returns the Warcraft3-type of the input object. E.g. Debug.wc3Type(Player(0)) will return "player".
    *        - Returns type(object), if used on Lua-objects.
    *    table.tostring(whichTable [, depth:integer] [, pretty_yn:boolean])
    *        - Creates a list of all (key,value)-pairs from the specified table. Also lists subtable entries up to the specified depth (unlimited, if not specified).
    *        - E.g. for T = {"a", 5, {7}}, table.tostring(T) would output '{(1, "a"), (2, 5), (3, {(1, 7)})}' (if using concise style, i.e. pretty_yn being nil or false).
    *        - Not specifying a depth can potentially lead to a stack overflow for self-referential tables (e.g X = {}; X[1] = X). Choose a sensible depth to prevent this (in doubt start with 1 and test upwards).
    *        - Supports pretty style by setting pretty_yn to true. Pretty style is linebreak-separated, uses indentations and has other visual improvements. Use it on small tables only, because Wc3 can't show that many linebreaks at once.
    *        - All of the following is valid syntax: table.tostring(T), table.tostring(T, depth), table.tostring(T, pretty_yn) or table.tostring(T, depth, pretty_yn).
    *        - table.tostring is not multiplayer-synced.
    *    table.print(whichTable [, depth:integer] [, pretty_yn:boolean])
    *        - Prints table.tostring(...).
    *
    ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]

    -- disable sumneko extension warnings for imported resource
    ---@diagnostic disable

    ----------------
    --| Settings |--
    ----------------

    Debug = {
        --BEGIN OF SETTINGS--
        settings = {
            --Ingame Error Messages
            SHOW_TRACE_ON_ERROR = true                      ---Set to true to show a stack trace on every error in addition to the regular message (msg sources: automatic error handling, Debug.try, Debug.throwError, ...)
        ,   INCLUDE_DEBUGUTILS_INTO_TRACE = true            ---Set to true to include lines from Debug Utils into the stack trace. Those show the source of error handling, which you might consider redundant.
        ,   USE_TRY_ON_TRIGGERADDACTION = true              ---Set to true for automatic error handling on TriggerAddAction (applies Debug.try on every trigger action).
        ,   USE_TRY_ON_CONDITION = true                     ---Set to true for automatic error handling on boolexpressions created via Condition() or Filter() (essentially applies Debug.try on every trigger condition).
        ,   USE_TRY_ON_TIMERSTART = true                    ---Set to true for automatic error handling on TimerStart (applies Debug.try on every timer callback).
        ,   USE_TRY_ON_ENUMFUNCS = true                     ---Set to true for automatic error handling on ForGroup, ForForce, EnumItemsInRect and EnumDestructablesInRect (applies Debug.try on every enum callback)
        ,   USE_TRY_ON_COROUTINES = true                    ---Set to true for improved stack traces on errors within coroutines (applies Debug.try on coroutine.create and coroutine.wrap). This lets stack traces point to the erroneous function executed within the coroutine (instead of the function creating the coroutine).
            --Ingame Console and -exec
        ,   ALLOW_INGAME_CODE_EXECUTION = true              ---Set to true to enable IngameConsole and -exec command.
            --Warnings for nil globals
        ,   WARNING_FOR_NIL_GLOBALS = true                  ---Set to true to print warnings upon accessing nil-globals (i.e. globals containing no value).
        ,   SHOW_TRACE_FOR_NIL_WARNINGS = false              ---Set to true to include a stack trace into nil-warnings.
        ,   EXCLUDE_BJ_GLOBALS_FROM_NIL_WARNINGS = false    ---Set to true to exclude bj_ variables from nil-warnings.
        ,   EXCLUDE_INITIALIZED_GLOBALS_FROM_NIL_WARNINGS = true  ---Set to true to disable warnings for initialized globals, (i.e. nil globals that held a value at some point will be treated intentionally nilled and no longer prompt warnings).
            --Print Caching
        ,   USE_PRINT_CACHE = true                          ---Set to true to let print()-calls during loading screen be cached until the game starts.
        ,   PRINT_DURATION = nil                            ---@type float Adjusts the duration in seconds that values printed by print() last on screen. Set to nil to use default duration (which depends on string length).
            --Name Caching
        ,   USE_NAME_CACHE = true                           ---Set to true to let tostring/print output the string-name of an object instead of its memory location (except for booleans/numbers/strings). E.g. print(CreateUnit) will output "function: CreateUnit" instead of "function: 0063A698".
        ,   AUTO_REGISTER_NEW_NAMES = true                  ---Automatically adds new names from global scope (and subtables of _G up to NAME_CACHE_DEPTH) to the name cache by adding metatables with the __newindex metamethod to ALL tables accessible from global scope.
        ,   NAME_CACHE_DEPTH = 4                            ---Set to 0 to only affect globals. Experimental feature: Set to an integer > 0 to also cache names for subtables of _G (up to the specified depth). Warning: This will alter the __newindex metamethod of subtables of _G (but not break existing functionality).
            --Colors
        ,   colors = {
                error = 'ff5555'                            ---@type string Color to be applied to error messages
            ,   log = '888888'                              ---@type string Color to be applied to logged messages through Debug.log().
            ,   nilWarning = 'ffffff'                       ---@type string Color to be applied to nil-warnings.
            }
        }
        --END OF SETTINGS--
        --START OF CODE--
    ,   data = {
            nameCache = {}                                  ---@type table<any,string> contains the string names of any object in global scope (random for objects that have multiple names)
        ,   nameCacheMirror = {}                            ---@type table<string,any> contains the (name,object)-pairs of all objects in the name cache. Used to prevent name duplicates that might otherwise occur upon reassigning globals.
        ,   nameDepths = {}                                 ---@type table<any,integer> contains the depth of the name used by by any object in the name cache (i.e. the depth within the parentTable).
        ,   autoIndexedTables = {}                          ---@type table<table,boolean> contains (t,true), if DebugUtils already set a __newindex metamethod for name caching in t. Prevents double application.
        ,   paramLog = {}                                   ---@type table<string,string> saves logged information per code location. to be filled by Debug.log(), to be printed by Debug.try()
        ,   sourceMap = {{firstLine= 1,file='DebugUtils'}}  ---@type table<integer,{firstLine:integer,file:string,lastLine?:integer}> saves lines and file names of all documents registered via Debug.beginFile().
        ,   printCache = {n=0}                              ---@type string[] contains the strings that were attempted to print during loading screen.
        ,   globalWarningExclusions = {}                    ---@type table<string,boolean> contains global variable names that should be excluded from warnings.
        ,   printErrors_yn = true                           ---@type boolean Set to false to disable error messages. Used by Debug.first.
        ,   firstError = nil                                ---@type string? contains the first error that was thrown. Used by Debug.first.
        }
    }
    --localization
    local settings, paramLog, nameCache, nameDepths, autoIndexedTables, nameCacheMirror, sourceMap, printCache, data = Debug.settings, Debug.data.paramLog, Debug.data.nameCache, Debug.data.nameDepths, Debug.data.autoIndexedTables, Debug.data.nameCacheMirror, Debug.data.sourceMap, Debug.data.printCache, Debug.data

    --Write DebugUtils first line number to sourceMap:
    ---@diagnostic disable-next-line
    Debug.data.sourceMap[1].firstLine = tonumber(codeLoc:match(":\x25d+"):sub(2,-1))

    -------------------------------------------------
    --| File Indexing for local Error Msg Support |--
    -------------------------------------------------

    -- Functions for war3map.lua -> local file conversion for error messages.

    ---Returns the line number in war3map.lua, where this is called (for depth = 0).
    ---Choose a depth d > 0 to instead return the line, where the d-th function in the stack leading to this call is executed.
    ---@param depth? integer default: 0.
    ---@return number?
    function Debug.getLine(depth)
        depth = depth or 0
        local _, location = pcall(error, "", depth + 3) ---@diagnostic disable-next-line
        local line = location:match(":\x25d+") --extracts ":1000" from "war3map.lua:1000:..."
        return tonumber(line and line:sub(2,-1)) --check if line is nil before applying string.sub to prevent errors (nil can result from string.match above, although it should never do so in our case)
    end

    ---Tells the Debug library that the specified file begins exactly here (i.e. in the line, where this is called).
    ---
    ---Using this improves stack traces of error messages. Stack trace will have "war3map.lua"-references between this and the next Debug.endFile() converted to file-specific references.
    ---
    ---To be called in the Lua root in Line 1 of every file you wish to track! Line 1 means exactly line 1, before any comment! This way, the line shown in the trace will exactly match your IDE.
    ---
    ---If you want to use a custom wrapper around Debug.beginFile(), you need to increase the depth parameter to 1 to record the line of the wrapper instead of the line of Debug.beginFile().
    ---@param fileName string
    ---@param depth? integer default: 0. Set to 1, if you call this from a wrapper (and use the wrapper in line 1 of every document).
    ---@param lastLine? integer Ignore this. For compatibility with Total Initialization.
    function Debug.beginFile(fileName, depth, lastLine)
        depth, fileName = depth or 0, fileName or '' --filename is not actually optional, we just default to '' to prevent crashes.
        local line = Debug.getLine(depth + 1)
        if line then --for safety reasons. we don't want to add a non-existing line to the sourceMap
            table.insert(sourceMap, {firstLine = line, file = fileName, lastLine = lastLine}) --automatically sorted list, because calls of Debug.beginFile happen logically in the order of the map script.
        end
    end

    ---Tells the Debug library that the file previously started with Debug.beginFile() ends here.
    ---This is in theory optional to use, as the next call of Debug.beginFile will also end the previous. Still good practice to always use this in the last line of every file.
    ---If you want to use a custom wrapper around Debug.endFile(), you need to increase the depth parameter to 1 to record the line of the wrapper instead of the line of Debug.endFile().
    ---@param depth? integer
    function Debug.endFile(depth)
        depth = depth or 0
        local line = Debug.getLine(depth + 1)
        sourceMap[#sourceMap].lastLine = line
    end

    ---Takes an error message containing a file and a linenumber and converts both to local file and line as saved to Debug.sourceMap.
    ---@param errorMsg string must be formatted like "<document>:<linenumber><RestOfMsg>".
    ---@return string convertedMsg a string of the form "<localDocument>:<localLinenumber><RestOfMsg>"
    function Debug.getLocalErrorMsg(errorMsg)
        local startPos, endPos = errorMsg:find(":\x25d*") --start and end position of line number. The part before that is the document, part after the error msg.
        if startPos and endPos then --can be nil, if input string was not of the desired form "<document>:<linenumber><RestOfMsg>".
            local document, line, rest = errorMsg:sub(1, startPos), tonumber(errorMsg:sub(startPos+1, endPos)), errorMsg:sub(endPos+1, -1) --get error line in war3map.lua
            if document == 'war3map.lua:' and line then --only convert war3map.lua-references to local position. Other files such as Blizzard.j.lua are not converted (obiously).
                for i = #sourceMap, 1, -1 do --find local file containing the war3map.lua error line.
                    if line >= sourceMap[i].firstLine then --war3map.lua line is part of sourceMap[i].file
                        if not sourceMap[i].lastLine or line <= sourceMap[i].lastLine then --if lastLine is given, we must also check for it
                            return sourceMap[i].file .. ":" .. (line - sourceMap[i].firstLine + 1) .. rest
                        else --if line is larger than firstLine and lastLine of sourceMap[i], it is not part of a tracked file -> return global war3map.lua position.
                            break --prevent return within next step of the loop ("line >= sourceMap[i].firstLine" would be true again, but wrong file)
                        end
                    end
                end
            end
        end
        return errorMsg
    end
    local convertToLocalErrorMsg = Debug.getLocalErrorMsg

    ----------------------
    --| Error Handling |--
    ----------------------

    local concat
    ---Applies tostring() on all input params and concatenates them 4-space-separated.
    ---@param firstParam any
    ---@param ... any
    ---@return string
    concat = function(firstParam, ...)
        if select('#', ...) == 0 then
            return tostring(firstParam)
        end
        return tostring(firstParam) .. '    ' .. concat(...)
    end

    ---Returns the stack trace between the specified startDepth and endDepth.
    ---The trace lists file names and line numbers. File name is only listed, if it has changed from the previous traced line.
    ---The previous file can also be specified as an input parameter to suppress the first file name in case it's identical.
    ---@param startDepth integer
    ---@param endDepth integer
    ---@return string trace
    local function getStackTrace(startDepth, endDepth)
        local trace, separator = "", ""
        local _, currentFile, lastFile, tracePiece, lastTracePiece
        for loopDepth = startDepth, endDepth do --get trace on different depth level
            _, tracePiece = pcall(error, "", loopDepth) ---@type boolean, string
            tracePiece = convertToLocalErrorMsg(tracePiece)
            if #tracePiece > 0 and lastTracePiece ~= tracePiece then --some trace pieces can be empty, but there can still be valid ones beyond that
                currentFile = tracePiece:match("^.-:")
                --Hide DebugUtils in the stack trace (except main reference), if settings.INCLUDE_DEBUGUTILS_INTO_TRACE is set to true.
                if settings.INCLUDE_DEBUGUTILS_INTO_TRACE or (loopDepth == startDepth) or currentFile ~= "DebugUtils:" then
                    trace = trace .. separator .. ((currentFile == lastFile) and tracePiece:match(":\x25d+"):sub(2,-1) or tracePiece:match("^.-:\x25d+"))
                    lastFile, lastTracePiece, separator = currentFile, tracePiece, " <- "
                end
            end
        end
        return trace
    end

    ---Message Handler to be used by the try-function below.
    ---Adds stack trace plus formatting to the message and prints it.
    ---@param errorMsg string
    ---@param startDepth? integer default: 4 for use in xpcall
    local function errorHandler(errorMsg, startDepth)
        startDepth = startDepth or 4 --xpcall doesn't specify this param, so it must default to 4 for this case
        errorMsg = convertToLocalErrorMsg(errorMsg)
        --Original error message and stack trace.
        local toPrint = "|cff" .. settings.colors.error .. "ERROR at " .. errorMsg .. "|r"
        if settings.SHOW_TRACE_ON_ERROR then
            toPrint = toPrint .. "\n|cff" .. settings.colors.error .. "Traceback (most recent call first):|r\n|cff" .. settings.colors.error .. getStackTrace(startDepth,200) .. "|r"
        end
        --Also print entries from param log, if there are any.
        for location, loggedParams in pairs(paramLog) do
            toPrint = toPrint .. "\n|cff" .. settings.colors.log .. "Logged at " .. convertToLocalErrorMsg(location) .. loggedParams .. "|r"
            paramLog[location] = nil
        end
        data.firstError = data.firstError or toPrint
        if data.printErrors_yn then --don't print error, if execution of Debug.firstError() has disabled it.
            print(toPrint)
        end
    end

    ---Tries to execute the specified function with the specified parameters in protected mode and prints an error message (including stack trace), if unsuccessful.
    ---
    ---Example use: Assume you have a code line like "CreateUnit(0,1,2)", which doesn't work and you want to know why.
    ---* Option 1: Change it to "Debug.try(CreateUnit, 0, 1, 2)", i.e. separate the function from the parameters.
    ---* Option 2: Change it to "Debug.try(function() return CreateUnit(0,1,2) end)", i.e. pack it into an anonymous function. You can skip the "return", if you don't need the return values.
    ---When no error occured, the try-function will return all values returned by the input function.
    ---When an error occurs, try will print the resulting error and stack trace.
    ---@param funcToExecute function the function to call in protected mode
    ---@param ... any params for the input-function
    ---@return ... any
    function Debug.try(funcToExecute, ...)
        return select(2, xpcall(funcToExecute, errorHandler,...))
    end
    ---@diagnostic disable-next-line lowercase-global
    try = Debug.try

    ---Prints "ERROR:" and the specified error objects on the Screen. Also prints the stack trace leading to the error. You can specify as many arguments as you wish.
    ---
    ---In contrast to Lua's native error function, this can be called outside of protected mode and doesn't halt code execution.
    ---@param ... any objects/errormessages to be printed (doesn't have to be strings)
    function Debug.throwError(...)
        errorHandler(getStackTrace(4,4) .. ": " .. concat(...), 5)
    end

    ---Prints the specified error message, if the specified condition fails (i.e. if it resolves to false or nil).
    ---
    ---Returns all specified arguments after the errorMsg, if the condition holds.
    ---
    ---In contrast to Lua's native assert function, this can be called outside of protected mode and doesn't halt code execution (even in case of condition failure).
    ---@param condition any actually a boolean, but you can use any object as a boolean.
    ---@param errorMsg string the message to be printed, if the condition fails
    ---@param ... any will be returned, if the condition holds
    function Debug.assert(condition, errorMsg, ...)
        if condition then
            return ...
        else
            errorHandler(getStackTrace(4,4) .. ": " .. errorMsg, 5)
        end
    end

    ---Returns the stack trace at the code position where this function is called.
    ---The returned string includes war3map.lua/blizzard.j.lua code positions of all functions from the stack trace in the order of execution (most recent call last). It does NOT include function names.
    ---@return string
    function Debug.traceback()
        return getStackTrace(3,200)
    end

    ---Saves the specified parameters to the debug log at the location where this function is called. The Debug-log will be printed for all affected locations upon the try-function catching an error.
    ---The log is unique per code location: Parameters logged at code line x will overwrite the previous ones logged at x. Parameters logged at different locations will all persist and be printed.
    ---@param ... any save any information, for instance the parameters of the function call that you are logging.
    function Debug.log(...)
        local _, location = pcall(error, "", 3) ---@diagnostic disable-next-line: need-check-nil
        paramLog[location or ''] = concat(...)
    end

    ---Re-prints the very first error that occured during map runtime and prevents any further error messages and nil-warnings from being printed afterwards (for the rest of the game).
    ---Use this, if a constant stream of error messages hinders you from reading any of them.
    ---IngameConsole will still output error messages afterwards for code executed in it.
    function Debug.first()
        data.printErrors_yn = false
        print(data.firstError)
    end

    ----------------------------------
    --| Undeclared Global Warnings |--
    ----------------------------------

    --Utility function here. _G metatable behaviour is defined in Gamestart section further below.

    local globalWarningExclusions = Debug.data.globalWarningExclusions

    ---Disables nil-warnings for the specified variable.
    ---@param variableName string
    function Debug.disableNilWarningsFor(variableName)
        globalWarningExclusions[variableName] = true
    end

    ------------------------------------
    --| Name Caching (API-functions) |--
    ------------------------------------

    --Help-table. The registerName-functions below shall not work on call-by-value-types, i.e. booleans, strings and numbers (renaming a value of any primitive type doesn't make sense).
    local skipType = {boolean = true, string = true, number = true, ['nil'] = true}
    --Set weak keys to nameCache and nameDepths and weak values for nameCacheMirror to prevent garbage collection issues
    setmetatable(nameCache, {__mode = 'k'})
    setmetatable(nameDepths, getmetatable(nameCache))
    setmetatable(nameCacheMirror, {__mode = 'v'})

    ---Removes the name from the name cache, if already used for any object (freeing it for the new object). This makes sure that a name is always unique.
    ---This doesn't solve the 
    ---@param name string
    local function removeNameIfNecessary(name)
        if nameCacheMirror[name] then
            nameCache[nameCacheMirror[name]] = nil
            nameCacheMirror[name] = nil
        end
    end

    ---Registers a name for the specified object, which will be the future output for tostring(whichObject).
    ---You can overwrite existing names for whichObject by using this.
    ---@param whichObject any
    ---@param name string
    function Debug.registerName(whichObject, name)
        if not skipType[type(whichObject)] then
            removeNameIfNecessary(name)
            nameCache[whichObject] = name
            nameCacheMirror[name] = whichObject
            nameDepths[name] = 0
        end
    end

    ---Registers a new name to the nameCache as either just <key> (if parentTableName is the empty string), <table>.<key> (if parentTableName is given and string key doesn't contain whitespace) or <name>[<key>] notation (for other keys in existing tables).
    ---Only string keys without whitespace support <key>- and <table>.<key>-notation. All other keys require a parentTableName.
    ---@param parentTableName string | '""' empty string suppresses <table>-affix.
    ---@param key any
    ---@param object any only call-be-ref types allowed
    ---@param parentTableDepth? integer
    local function addNameToCache(parentTableName, key, object, parentTableDepth)
        parentTableDepth = parentTableDepth or -1
        --Don't overwrite existing names for the same object, don't add names for primitive types.
        if nameCache[object] or skipType[type(object)] then
            return
        end
        local name
        --apply dot-syntax for string keys without whitespace
        if type(key) == 'string' and not string.find(key, "\x25s") then
            if parentTableName == "" then
                name = key
                nameDepths[object] = 0
            else
                name =  parentTableName .. "." .. key
                nameDepths[object] = parentTableDepth + 1
            end
            --apply bracket-syntax for all other keys. This requires a parentTableName.
        elseif parentTableName ~= "" then
            name = type(key) == 'string' and ('"' .. key .. '"') or key
            name = parentTableName .. "[" .. tostring(name) .. "]"
            nameDepths[object] = parentTableDepth + 1
        end
        --Stop in cases without valid name (like parentTableName = "" and key = [1])
        if name then
            removeNameIfNecessary(name)
            nameCache[object] = name
            nameCacheMirror[name] = object
        end
    end

    ---Registers all call-by-reference objects in the given parentTable to the nameCache.
    ---Automatically filters out primitive objects and already registed Objects.
    ---@param parentTable table
    ---@param parentTableName? string
    local function registerAllObjectsInTable(parentTable, parentTableName)
        parentTableName = parentTableName or nameCache[parentTable] or ""
        --Register all call-by-ref-objects in parentTable
        for key, object in pairs(parentTable) do
            addNameToCache(parentTableName, key, object, nameDepths[parentTable])
        end
    end

    ---Adds names for all values of the specified parentTable to the name cache. Names will be "<parentTableName>.<key>" or "<parentTableName>[<key>]", depending on the key type.
    ---
    ---Example: Given a table T = {f = function() end, [1] = {}}, tostring(T.f) and tostring(T[1]) will output "function: T.f" and "table: T[1]" respectively after running Debug.registerNamesFrom(T).
    ---The name of T itself must either be specified as an input parameter OR have previously been registered. It can also be suppressed by inputting the empty string (so objects will just display by their own names).
    ---The names of objects in global scope are automatically registered during loading screen.
    ---@param parentTable table base table of which all entries shall be registered (in the Form parentTableName.objectName).
    ---@param parentTableName? string|'""' Nil: takes <parentTableName> as previously registered. Empty String: Skips <parentTableName> completely. String <s>: Objects will show up as "<s>.<objectName>".
    ---@param depth? integer objects within sub-tables up to the specified depth will also be added. Default: 1 (only elements of whichTable). Must be >= 1.
    ---@overload fun(parentTable:table, depth:integer)
    function Debug.registerNamesFrom(parentTable, parentTableName, depth)
        --Support overloaded definition fun(parentTable:table, depth:integer)
        if type(parentTableName) == 'number' then
            depth = parentTableName
            parentTableName = nil
        end
        --Apply default values
        depth = depth or 1
        parentTableName = parentTableName or nameCache[parentTable] or ""
        --add name of T in case it hasn't already
        if not nameCache[parentTable] and parentTableName ~= "" then
            Debug.registerName(parentTable, parentTableName)
        end
        --Register all call-by-ref-objects in parentTable. To be preferred over simple recursive approach to ensure that top level names are preferred.
        registerAllObjectsInTable(parentTable, parentTableName)
        --if depth > 1 was specified, also register Names from subtables.
        if depth > 1 then
            for _, object in pairs(parentTable) do
                if type(object) == 'table' then
                    Debug.registerNamesFrom(object, nil, depth - 1)
                end
            end
        end
    end

    -------------------------------------------
    --| Name Caching (Loading Screen setup) |--
    -------------------------------------------

    ---Registers all existing object names from global scope and Lua incorporated libraries to be used by tostring() overwrite below.
    local function registerNamesFromGlobalScope()
        --Add all names from global scope to the name cache.
        Debug.registerNamesFrom(_G, "")
        --Add all names of Warcraft-enabled Lua libraries as well:
        --Could instead add a depth to the function call above, but we want to ensure that these libraries are added even if the user has chosen depth 0.
        for _, lib in ipairs({coroutine, math, os, string, table, utf8, Debug}) do
            Debug.registerNamesFrom(lib)
        end
        --Add further names that are not accessible from global scope:
        --Player(i)
        for i = 0, GetBJMaxPlayerSlots() - 1 do
            Debug.registerName(Player(i), "Player(" .. i .. ")")
        end
    end

    --Set empty metatable to _G. __index is added when game starts (for "attempt to read nil-global"-errors), __newindex is added right below (for building the name cache).
    setmetatable(_G, getmetatable(_G) or {}) --getmetatable(_G) should always return nil provided that DebugUtils is the topmost script file in the trigger editor, but we still include this for safety-

    -- Save old tostring into Debug Library before overwriting it.
    Debug.oldTostring = tostring

    if settings.USE_NAME_CACHE then
        local oldTostring = tostring
        tostring = function(obj) --new tostring(CreateUnit) prints "function: CreateUnit"
            --tostring of non-primitive object is NOT guaranteed to be like "<type>:<hex>", because it might have been changed by some __tostring-metamethod.
            if settings.USE_NAME_CACHE then --return names from name cache only if setting is enabled. This allows turning it off during runtime (via Ingame Console) to revert to old tostring.
                return nameCache[obj] and ((oldTostring(obj):match("^.-: ") or (oldTostring(obj) .. ": ")) .. nameCache[obj]) or oldTostring(obj)
            end
            return Debug.oldTostring(obj)
        end
        --Add names to Debug.data.objectNames within Lua root. Called below the other Debug-stuff to get the overwritten versions instead of the original ones.
        registerNamesFromGlobalScope()

        --Prepare __newindex-metamethod to automatically add new names to the name cache
        if settings.AUTO_REGISTER_NEW_NAMES then
            local nameRegisterNewIndex
            ---__newindex to be used for _G (and subtables up to a certain depth) to automatically register new names to the nameCache.
            ---Tables in global scope will use their own name. Subtables of them will use <parentName>.<childName> syntax.
            ---Global names don't support container[key]-notation (because "_G[...]" is probably not desired), so we only register string type keys instead of using prettyTostring.
            ---@param t table
            ---@param k any
            ---@param v any
            ---@param skipRawset? boolean set this to true when combined with another __newindex. Suppresses rawset(t,k,v) (because the other __newindex is responsible for that).
            nameRegisterNewIndex = function(t,k,v, skipRawset)
                local parentDepth = nameDepths[t] or 0
                --Make sure the parent table has an existing name before using it as part of the child name
                if t == _G or nameCache[t] then
                    local existingName = nameCache[v]
                    if not existingName then
                        addNameToCache((t == _G and "") or nameCache[t], k, v, parentDepth)
                    end
                    --If v is a table and the parent table has a valid name, inherit __newindex to v's existing metatable (or create a new one), if that wasn't already done.
                    if type(v) == 'table' and nameDepths[v] < settings.NAME_CACHE_DEPTH then
                        if not existingName then
                            --If v didn't have a name before, also add names for elements contained in v by construction (like v = {x = function() end} ).
                            Debug.registerNamesFrom(v, settings.NAME_CACHE_DEPTH - nameDepths[v])
                        end
                        --Apply __newindex to new tables.
                        if not autoIndexedTables[v] then
                            autoIndexedTables[v] = true
                            local mt = getmetatable(v)
                            if not mt then
                                mt = {}
                                setmetatable(v, mt) --only use setmetatable when we are sure there wasn't any before to prevent issues with "__metatable"-metamethod.
                            end
                            ---@diagnostic disable-next-line: assign-type-mismatch
                            local existingNewIndex = mt.__newindex
                            local isTable_yn = (type(existingNewIndex) == 'table')
                            --If mt has an existing __newindex, add the name-register effect to it (effectively create a new __newindex using the old)
                            if existingNewIndex then
                                mt.__newindex = function(t,k,v)
                                    nameRegisterNewIndex(t,k,v, true) --setting t[k] = v might not be desired in case of existing newindex. Skip it and let existingNewIndex make the decision.
                                    if isTable_yn then
                                        existingNewIndex[k] = v
                                    else
                                        return existingNewIndex(t,k,v)
                                    end
                                end
                            else
                                --If mt doesn't have an existing __newindex, add one that adds the object to the name cache.
                                mt.__newindex = nameRegisterNewIndex
                            end
                        end
                    end
                end
                --Set t[k] = v.
                if not skipRawset then
                    rawset(t,k,v)
                end
            end

            --Apply metamethod to _G.
            local existingNewIndex = getmetatable(_G).__newindex --should always be nil provided that DebugUtils is the topmost script in your trigger editor. Still included for safety.
            local isTable_yn = (type(existingNewIndex) == 'table')
            if existingNewIndex then
                getmetatable(_G).__newindex = function(t,k,v)
                    nameRegisterNewIndex(t,k,v, true)
                    if isTable_yn then
                        existingNewIndex[k] = v
                    else
                        existingNewIndex(t,k,v)
                    end
                end
            else
                getmetatable(_G).__newindex = nameRegisterNewIndex
            end
        end
    end

    ------------------------------------------------------
    --| Native Overwrite for Automatic Error Handling  |--
    ------------------------------------------------------

    --A table to store the try-wrapper for each function. This avoids endless re-creation of wrapper functions within the hooks below.
    --Weak keys ensure that garbage collection continues as normal.
    local tryWrappers = setmetatable({}, {__mode = 'k'}) ---@type table<function,function>
    local try = Debug.try

    ---Takes a function and returns a wrapper executing the same function within Debug.try.
    ---Wrappers are permanently stored (until the original function is garbage collected) to ensure that they don't have to be created twice for the same function.
    ---@param func? function
    ---@return function
    local function getTryWrapper(func)
        if func then
            tryWrappers[func] = tryWrappers[func] or function(...) return try(func, ...) end
        end
        return tryWrappers[func] --returns nil for func = nil (important for TimerStart overwrite below)
    end

    --Overwrite TriggerAddAction, TimerStart, Condition, Filter and Enum natives to let them automatically apply Debug.try.
    --Also overwrites coroutine.create and coroutine.wrap to let stack traces point to the function executed within instead of the function creating the coroutine.
    if settings.USE_TRY_ON_TRIGGERADDACTION then
        local originalTriggerAddAction = TriggerAddAction
        TriggerAddAction = function(whichTrigger, actionFunc)
            return originalTriggerAddAction(whichTrigger, getTryWrapper(actionFunc))
        end
    end
    if settings.USE_TRY_ON_TIMERSTART then
        local originalTimerStart = TimerStart
        TimerStart = function(whichTimer, timeout, periodic, handlerFunc)
            originalTimerStart(whichTimer, timeout, periodic, getTryWrapper(handlerFunc))
        end
    end
    if settings.USE_TRY_ON_CONDITION then
        local originalCondition = Condition
        Condition = function(func)
            return originalCondition(getTryWrapper(func))
        end
        Filter = Condition
    end
    if settings.USE_TRY_ON_ENUMFUNCS then
        local originalForGroup = ForGroup
        ForGroup = function(whichGroup, callback)
            originalForGroup(whichGroup, getTryWrapper(callback))
        end
        local originalForForce = ForForce
        ForForce = function(whichForce, callback)
            originalForForce(whichForce, getTryWrapper(callback))
        end
        local originalEnumItemsInRect = EnumItemsInRect
        EnumItemsInRect = function(r, filter, actionfunc)
            originalEnumItemsInRect(r, filter, getTryWrapper(actionfunc))
        end
        local originalEnumDestructablesInRect = EnumDestructablesInRect
        EnumDestructablesInRect = function(r, filter, actionFunc)
            originalEnumDestructablesInRect(r, filter, getTryWrapper(actionFunc))
        end
    end
    if settings.USE_TRY_ON_COROUTINES then
        local originalCoroutineCreate = coroutine.create
        ---@diagnostic disable-next-line: duplicate-set-field
        coroutine.create = function(f)
            return originalCoroutineCreate(getTryWrapper(f))
        end
        local originalCoroutineWrap = coroutine.wrap
        ---@diagnostic disable-next-line: duplicate-set-field
        coroutine.wrap = function(f)
            return originalCoroutineWrap(getTryWrapper(f))
        end
    end

    ------------------------------------------
    --| Cache prints during Loading Screen |--
    ------------------------------------------

    -- Apply the duration as specified in the settings.
    if settings.PRINT_DURATION then
        local display, getLocalPlayer, dur = DisplayTimedTextToPlayer, GetLocalPlayer, settings.PRINT_DURATION
        print = function(...) ---@diagnostic disable-next-line: param-type-mismatch
        display(getLocalPlayer(), 0, 0, dur, concat(...))
        end
    end

    -- Delay loading screen prints to after game start.
    if settings.USE_PRINT_CACHE then
        local oldPrint = print
        --loading screen print will write the values into the printCache
        print = function(...)
            if bj_gameStarted then
                oldPrint(...)
            else --during loading screen only: concatenate input arguments 4-space-separated, implicitely apply tostring on each, cache to table
                ---@diagnostic disable-next-line
                printCache.n = printCache.n + 1
                printCache[printCache.n] = concat(...)
            end
        end
    end

    --------------------------------
    --| Warnings for Nil Globals |--
    --------------------------------

    --Exclude initialized globals from warnings, even if initialized with nil.
    --These warning exclusions take effect immediately, while the warnings take effect at game start (see code after MarkGameStarted below).
    if settings.WARNING_FOR_NIL_GLOBALS and settings.EXCLUDE_INITIALIZED_GLOBALS_FROM_NIL_WARNINGS then
        local existingNewIndex = getmetatable(_G).__newindex
        local isTable_yn = (type(existingNewIndex) == 'table')
        getmetatable(_G).__newindex = function(t,k,v)
            --First, exclude the initialized global from future warnings
            globalWarningExclusions[k] = true
            --Second, execute existing newindex, if there is one in place.
            if existingNewIndex then
                if isTable_yn then
                    existingNewIndex[k] = v
                else
                    existingNewIndex(t,k,v)
                end
            else
                rawset(t,k,v)
            end
        end
    end

    -------------------------
    --| Modify Game Start |--
    -------------------------

    local originalMarkGameStarted = MarkGameStarted
    --Hook certain actions into the start of the game.
    MarkGameStarted = function()
        originalMarkGameStarted()
        if settings.WARNING_FOR_NIL_GLOBALS then
            local existingIndex = getmetatable(_G).__index
            local isTable_yn = (type(existingIndex) == 'table')
            getmetatable(_G).__index = function(t, k) --we made sure that _G has a metatable further above.
                --Don't show warning, if the variable name has been actively excluded or if it's a bj_ variable (and those are excluded).
                if data.printErrors_yn and (not globalWarningExclusions[k]) and ((not settings.EXCLUDE_BJ_GLOBALS_FROM_NIL_WARNINGS) or string.sub(tostring(k),1,3) ~= 'bj_') then --prevents intentionally nilled bj-variables from triggering the check within Blizzard.j-functions, like bj_cineFadeFinishTimer.
                    print("|cff" .. settings.colors.nilWarning .. "Trying to read nil global at " .. getStackTrace(4,4) .. ": " .. tostring(k) .. "|r"
                            .. (settings.SHOW_TRACE_FOR_NIL_WARNINGS and "\n|cff" .. settings.colors.nilWarning .. "Traceback (most recent call first):|r\n|cff" .. settings.colors.nilWarning .. getStackTrace(4,200) .. "|r" or ""))
                end
                if existingIndex then
                    if isTable_yn then
                        return existingIndex[k]
                    end
                    return existingIndex(t,k)
                end
                return rawget(t,k)
            end
        end

        --Add names to Debug.data.objectNames again to ensure that overwritten natives also make it to the name cache.
        --Overwritten natives have a new value, but the old key, so __newindex didn't trigger. But we can be sure that objectNames[v] doesn't yet exist, so adding again is safe.
        if settings.USE_NAME_CACHE then
            for _,v in pairs(_G) do
                nameCache[v] = nil
            end
            registerNamesFromGlobalScope()
        end

        --Print messages that have been cached during loading screen.
        if settings.USE_PRINT_CACHE then
            --Note that we don't restore the old print. The overwritten variant only applies caching behaviour to loading screen prints anyway and "unhooking" always adds other risks.
            for _, str in ipairs(printCache) do
                print(str)
            end ---@diagnostic disable-next-line: cast-local-type
        printCache = nil --frees reference for the garbage collector
        end

        --Create triggers listening to "-console" and "-exec" chat input.
        if settings.ALLOW_INGAME_CODE_EXECUTION and IngameConsole then
            IngameConsole.createTriggers()
        end
    end

    ---------------------
    --| Other Utility |--
    ---------------------

    do
        ---Returns the type of a warcraft object as string, e.g. "unit" upon inputting a unit.
        ---@param input any
        ---@return string
        function Debug.wc3Type(input)
            local typeString = type(input)
            if typeString == 'userdata' then
                typeString = tostring(input) --tostring returns the warcraft type plus a colon and some hashstuff.
                return typeString:sub(1, (typeString:find(":", nil, true) or 0) -1) --string.find returns nil, if the argument is not found, which would break string.sub. So we need to replace by 0.
            else
                return typeString
            end
        end
        Wc3Type = Debug.wc3Type --for backwards compatibility

        local conciseTostring, prettyTostring

        ---Translates a table into a comma-separated list of its (key,value)-pairs. Also translates subtables up to the specified depth.
        ---E.g. {"a", 5, {7}} will display as '{(1, "a"), (2, 5), (3, {(1, 7)})}'.
        ---@param object any
        ---@param depth? integer default: unlimited. Unlimited depth will throw a stack overflow error on self-referential tables.
        ---@return string
        conciseTostring = function (object, depth)
            depth = depth or -1
            if type(object) == 'string' then
                return '"' .. object .. '"'
            elseif depth ~= 0 and type(object) == 'table' then
                local elementArray = {}
                local keyAsString
                for k,v in pairs(object) do
                    keyAsString = type(k) == 'string' and ('"' .. tostring(k) .. '"') or tostring(k)
                    table.insert(elementArray, '(' .. keyAsString .. ', ' .. conciseTostring(v, depth -1) .. ')')
                end
                return '{' .. table.concat(elementArray, ', ') .. '}'
            end
            return tostring(object)
        end

        ---Creates a list of all (key,value)-pairs from the specified table. Also lists subtable entries up to the specified depth.
        ---Major differences to concise print are:
        --- * Format: Linebreak-formatted instead of one-liner, uses "[key] = value" instead of "(key,value)"
        --- * Will also unpack tables used as keys
        --- * Also includes the table's memory position as returned by tostring(table).
        --- * Tables referenced multiple times will only be unpacked upon first encounter and abbreviated on subsequent encounters
        --- * As a consequence, pretty version can be executed with unlimited depth on self-referential tables.
        ---@param object any
        ---@param depth? integer default: unlimited.
        ---@param constTable table
        ---@param indent string
        ---@return string
        prettyTostring = function(object, depth, constTable, indent)
            depth = depth or -1
            local objType = type(object)
            if objType == "string" then
                return '"'..object..'"' --wrap the string in quotes.
            elseif objType == 'table' and depth ~= 0 then
                if not constTable[object] then
                    constTable[object] = tostring(object):gsub(":","")
                    if next(object)==nil then
                        return constTable[object]..": {}"
                    else
                        local mappedKV = {}
                        for k,v in pairs(object) do
                            table.insert(mappedKV, '\n  ' .. indent ..'[' .. prettyTostring(k, depth - 1, constTable, indent .. "  ") .. '] = ' .. prettyTostring(v, depth - 1, constTable, indent .. "  "))
                        end
                        return constTable[object]..': {'.. table.concat(mappedKV, ',') .. '\n'..indent..'}'
                    end
                end
            end
            return constTable[object] or tostring(object)
        end

        ---Creates a list of all (key,value)-pairs from the specified table. Also lists subtable entries up to the specified depth.
        ---Supports concise style and pretty style.
        ---Concise will display {"a", 5, {7}} as '{(1, "a"), (2, 5), (3, {(1, 7)})}'.
        ---Pretty is linebreak-separated, so consider table size before converting. Pretty also abbreviates tables referenced multiple times.
        ---Can be called like table.tostring(T), table.tostring(T, depth), table.tostring(T, pretty_yn) or table.tostring(T, depth, pretty_yn).
        ---table.tostring is not multiplayer-synced.
        ---@param whichTable table
        ---@param depth? integer default: unlimited
        ---@param pretty_yn? boolean default: false (concise)
        ---@return string
        ---@overload fun(whichTable:table, pretty_yn?:boolean):string
        function table.tostring(whichTable, depth, pretty_yn)
            --reassign input params, if function was called as table.tostring(whichTable, pretty_yn)
            if type(depth) == 'boolean' then
                pretty_yn = depth
                depth = -1
            end
            return pretty_yn and prettyTostring(whichTable, depth, {}, "") or conciseTostring(whichTable, depth)
        end

        ---Prints a list of (key,value)-pairs contained in the specified table and its subtables up to the specified depth.
        ---Supports concise style and pretty style. Pretty is linebreak-separated, so consider table size before printing.
        ---Can be called like table.print(T), table.print(T, depth), table.print(T, pretty_yn) or table.print(T, depth, pretty_yn).
        ---@param whichTable table
        ---@param depth? integer default: unlimited
        ---@param pretty_yn? boolean default: false (concise)
        ---@overload fun(whichTable:table, pretty_yn?:boolean)
        function table.print(whichTable, depth, pretty_yn)
            print(table.tostring(whichTable, depth, pretty_yn))
        end
    end
end
Debug.endFile()
if Debug and Debug.beginFile then Debug.beginFile("IngameConsole") end
--[[

--------------------------
----| Ingame Console |----
--------------------------

/**********************************************
* Allows you to use the following ingame commands:
* "-exec <code>" to execute any code ingame.
* "-console" to start an ingame console interpreting any further chat input as code and showing both return values of function calls and error messages. Furthermore, the print function will print
*    directly to the console after it got started. You can still look up all print messages in the F12-log.
***********************
* -------------------
* |Using the console|
* -------------------
* Any (well, most) chat input by any player after starting the console is interpreted as code and directly executed. You can enter terms (like 4+5 or just any variable name), function calls (like print("bla"))
* and set-statements (like y = 5). If the code has any return values, all of them are printed to the console. Erroneous code will print an error message.
* Chat input starting with a hyphen is being ignored by the console, i.e. neither executed as code nor printed to the console. This allows you to still use other chat commands like "-exec" without prompting errors.
***********************
* ------------------
* |Multiline-Inputs|
* ------------------
* You can prevent a chat input from being immediately executed by preceeding it with the '>' character. All lines entered this way are halted, until any line not starting with '>' is being entered.
* The first input without '>' will execute all halted lines (and itself) in one chunk.
* Example of a chat input (the console will add an additional '>' to every line):
* >function a(x)
* >return x
* end
***********************
* Note that multiline inputs don't accept pure term evaluations, e.g. the following input is not supported and will prompt an error, while the same lines would have worked as two single-line inputs:
* >x = 5
* x
***********************
* -------------------
* |Reserved Keywords|
* -------------------
* The following keywords have a reserved functionality, i.e. are direct commands for the console and will not be interpreted as code:
* - 'help'          - will show a list of all reserved keywords along very short explanations.
* - 'exit'          - will shut down the console
* - 'share'         - will share the players console with every other player, allowing others to read and write into it. Will force-close other players consoles, if they have one active.
* - 'clear'         - will clear all text from the console, except the word 'clear'
* - 'lasttrace'     - will show the stack trace of the latest error that occured within IngameConsole
* - 'show'          - will show the console, after it was accidently hidden (you can accidently hide it by showing another multiboard, while the console functionality is still up and running).
* - 'printtochat'   - will let the print function return to normal behaviour (i.e. print to the chat instead of the console).
* - 'printtoconsole'- will let the print function print to the console (which is default behaviour).
* - 'autosize on'   - will enable automatic console resize depending on the longest string in the display. This is turned on by default.
* - 'autosize off'  - will disable automatic console resize and instead linebreak long strings into multiple lines.
* - 'textlang eng'  - lets the console use english Wc3 text language font size to compute linebreaks (look in your Blizzard launcher settings to find out)
* - 'textlang ger'  - lets the console use german Wc3 text language font size to compute linebreaks (look in your Blizzard launcher settings to find out)
***********************
* --------------
* |Paste Helper|
* --------------
* @Luashine has created a tool that simplifies pasting multiple lines of code from outside Wc3 into the IngameConsole.
* This is particularly useful, when you want to execute a large chunk of testcode containing several linebreaks.
* Goto: https://github.com/Luashine/wc3-debug-console-paste-helper#readme
*
*************************************************/
--]]

----------------
--| Settings |--
----------------

---@class IngameConsole
IngameConsole = {
    --Settings
    numRows = 20                        ---@type integer Number of Rows of the console (multiboard), excluding the title row. So putting 20 here will show 21 rows, first being the title row.
,   autosize = true                 ---@type boolean Defines, whether the width of the main Column automatically adjusts with the longest string in the display.
,   currentWidth = 0.5              ---@type number Current and starting Screen Share of the console main column.
,   mainColMinWidth = 0.3           ---@type number Minimum Screen share of the console main column.
,   mainColMaxWidth = 0.8           ---@type number Maximum Scren share of the console main column.
,   tsColumnWidth = 0.06            ---@type number Screen Share of the Timestamp Column
,   linebreakBuffer = 0.008         ---@type number Screen Share that is added to longest string in display to calculate the screen share for the console main column. Compensates for the small inaccuracy of the String Width function.
,   maxLinebreaks = 8               ---@type integer Defines the maximum amount of linebreaks, before the remaining output string will be cut and not further displayed.
,   printToConsole = true           ---@type boolean defines, if the print function should print to the console or to the chat
,   sharedConsole = false           ---@type boolean defines, if the console is displayed to each player at the same time (accepting all players input) or if all players much start their own console.
,   showTraceOnError = false        ---@type boolean defines, if the console shows a trace upon printing errors. Usually not too useful within console, because you have just initiated the erroneous call.
,   textLanguage = 'eng'            ---@type string text language of your Wc3 installation, which influences font size (look in the settings of your Blizzard launcher). Currently only supports 'eng' and 'ger'.
,   colors = {
        timestamp = "bbbbbb"            ---@type string Timestamp Color
    ,   singleLineInput = "ffffaa"  ---@type string Color to be applied to single line console inputs
    ,   multiLineInput = "ffcc55"   ---@type string Color to be applied to multi line console inputs
    ,   returnValue = "00ffff"      ---@type string Color applied to return values
    ,   error = "ff5555"            ---@type string Color to be applied to errors resulting of function calls
    ,   keywordInput = "ff00ff"     ---@type string Color to be applied to reserved keyword inputs (console reserved keywords)
    ,   info = "bbbbbb"             ---@type string Color to be applied to info messages from the console itself (for instance after creation or after printrestore)
    }
    --Privates
,   numCols = 2                     ---@type integer Number of Columns of the console (multiboard). Adjusting this requires further changes on code base.
,   player = nil                    ---@type player player for whom the console is being created
,   currentLine = 0                 ---@type integer Current Output Line of the console.
,   inputload = ''                  ---@type string Input Holder for multi-line-inputs
,   output = {}                     ---@type string[] Array of all output strings
,   outputTimestamps = {}           ---@type string[] Array of all output string timestamps
,   outputWidths = {}               ---@type number[] remembers all string widths to allow for multiboard resize
,   trigger = nil                   ---@type trigger trigger processing all inputs during console lifetime
,   multiboard = nil                ---@type multiboard
,   timer = nil                     ---@type timer gets started upon console creation to measure timestamps
,   errorHandler = nil              ---@type fun(errorMsg:string):string error handler to be used within xpcall. We create one per console to make it compatible with console-specific settings.
,   lastTrace = ''                  ---@type string trace of last error occured within console. To be printed via reserved keyword "lasttrace"
    --Statics
,   keywords = {}                   ---@type table<string,function> saves functions to be executed for all reserved keywords
,   playerConsoles = {}             ---@type table<player,IngameConsole> Consoles currently being active. up to one per player.
,   originalPrint = print           ---@type function original print function to restore, after the console gets closed.
}
IngameConsole.__index = IngameConsole
IngameConsole.__name = 'IngameConsole'

------------------------
--| Console Creation |--
------------------------

---Creates and opens up a new console.
---@param consolePlayer player player for whom the console is being created
---@return IngameConsole
function IngameConsole.create(consolePlayer)
    local new = {} ---@type IngameConsole
    setmetatable(new, IngameConsole)
    ---setup Object data
    new.player = consolePlayer
    new.output = {}
    new.outputTimestamps = {}
    new.outputWidths = {}
    --Timer
    new.timer = CreateTimer()
    TimerStart(new.timer, 3600., true, nil) --just to get TimeElapsed for printing Timestamps.
    --Trigger to be created after short delay, because otherwise it would fire on "-console" input immediately and lead to stack overflow.
    new:setupTrigger()
    --Multiboard
    new:setupMultiboard()
    --Create own error handler per console to be compatible with console-specific settings
    new:setupErrorHandler()
    --Share, if settings say so
    if IngameConsole.sharedConsole then
        new:makeShared() --we don't have to exit other players consoles, because we look for the setting directly in the class and there just logically can't be other active consoles.
    end
    --Welcome Message
    new:out('info', 0, false, "Console started. Any further chat input will be executed as code, except when beginning with \x22-\x22.")
    return new
end

---Creates the multiboard used for console display.
function IngameConsole:setupMultiboard()
    self.multiboard = CreateMultiboard()
    MultiboardSetRowCount(self.multiboard, self.numRows + 1) --title row adds 1
    MultiboardSetColumnCount(self.multiboard, self.numCols)
    MultiboardSetTitleText(self.multiboard, "Console")
    local mbitem
    for col = 1, self.numCols do
        for row = 1, self.numRows + 1 do --Title row adds 1
            mbitem = MultiboardGetItem(self.multiboard, row -1, col -1)
            MultiboardSetItemStyle(mbitem, true, false)
            MultiboardSetItemValueColor(mbitem, 255, 255, 255, 255)	-- Colors get applied via text color code
            MultiboardSetItemWidth(mbitem, (col == 1 and self.tsColumnWidth) or self.currentWidth )
            MultiboardReleaseItem(mbitem)
        end
    end
    mbitem = MultiboardGetItem(self.multiboard, 0, 0)
    MultiboardSetItemValue(mbitem, "|cffffcc00Timestamp|r")
    MultiboardReleaseItem(mbitem)
    mbitem = MultiboardGetItem(self.multiboard, 0, 1)
    MultiboardSetItemValue(mbitem, "|cffffcc00Line|r")
    MultiboardReleaseItem(mbitem)
    self:showToOwners()
end

---Creates the trigger that responds to chat events.
function IngameConsole:setupTrigger()
    self.trigger = CreateTrigger()
    TriggerRegisterPlayerChatEvent(self.trigger, self.player, "", false) --triggers on any input of self.player
    TriggerAddCondition(self.trigger, Condition(function() return string.sub(GetEventPlayerChatString(),1,1) ~= '-' end)) --console will not react to entered stuff starting with '-'. This still allows to use other chat orders like "-exec".
    TriggerAddAction(self.trigger, function() self:processInput(GetEventPlayerChatString()) end)
end

---Creates an Error Handler to be used by xpcall below.
---Adds stack trace plus formatting to the message.
function IngameConsole:setupErrorHandler()
    self.errorHandler = function(errorMsg)
        errorMsg = Debug.getLocalErrorMsg(errorMsg)
        local _, tracePiece, lastFile = nil, "", errorMsg:match("^.-:") or "<unknown>" -- errors on objects created within Ingame Console don't have a file and linenumber. Consider "x = {}; x[nil] = 5".
        local fullMsg = errorMsg .. "\nTraceback (most recent call first):\n" .. (errorMsg:match("^.-:\x25d+") or "<unknown>")
        --Get Stack Trace. Starting at depth 5 ensures that "error", "messageHandler", "xpcall" and the input error message are not included.
        for loopDepth = 5, 50 do --get trace on depth levels up to 50
            ---@diagnostic disable-next-line: cast-local-type, assign-type-mismatch
            _, tracePiece = pcall(error, "", loopDepth) ---@type boolean, string
            tracePiece = Debug.getLocalErrorMsg(tracePiece)
            if #tracePiece > 0 then --some trace pieces can be empty, but there can still be valid ones beyond that
                fullMsg = fullMsg .. " <- " .. ((tracePiece:match("^.-:") == lastFile) and tracePiece:match(":\x25d+"):sub(2,-1) or tracePiece:match("^.-:\x25d+"))
                lastFile = tracePiece:match("^.-:")
            end
        end
        self.lastTrace = fullMsg
        return "ERROR: " .. (self.showTraceOnError and fullMsg or errorMsg)
    end
end

---Shares this console with all players.
function IngameConsole:makeShared()
    local player
    for i = 0, GetBJMaxPlayers() -1 do
        player = Player(i)
        if (GetPlayerSlotState(player) == PLAYER_SLOT_STATE_PLAYING) and (IngameConsole.playerConsoles[player] ~= self) then --second condition ensures that the player chat event is not added twice for the same player.
            IngameConsole.playerConsoles[player] = self
            TriggerRegisterPlayerChatEvent(self.trigger, player, "", false) --triggers on any input
        end
    end
    self.sharedConsole = true
end

---------------------
--|      In       |--
---------------------

---Processes a chat string. Each input will be printed. Incomplete multiline-inputs will be halted until completion. Completed inputs will be converted to a function and executed. If they have an output, it will be printed.
---@param inputString string
function IngameConsole:processInput(inputString)
    --if the input is a reserved keyword, conduct respective actions and skip remaining actions.
    if IngameConsole.keywords[inputString] then --if the input string is a reserved keyword
        self:out('keywordInput', 1, false, inputString)
        IngameConsole.keywords[inputString](self) --then call the method with the same name. IngameConsole.keywords["exit"](self) is just self.keywords:exit().
        return
    end
    --if the input is a multi-line-input, queue it into the string buffer (inputLoad), but don't yet execute anything
    if string.sub(inputString, 1, 1) == '>' then --multiLineInput
        inputString = string.sub(inputString, 2, -1)
        self:out('multiLineInput',2, false, inputString)
        self.inputload = self.inputload .. inputString .. '\n'
    else --if the input is either singleLineInput OR the last line of multiLineInput, execute the whole thing.
        self:out(self.inputload == '' and 'singleLineInput' or 'multiLineInput', 1, false, inputString)
        self.inputload = self.inputload .. inputString
        local loadedFunc, errorMsg = load("return " .. self.inputload) --adds return statements, if possible (works for term statements)
        if loadedFunc == nil then
            loadedFunc, errorMsg = load(self.inputload)
        end
        self.inputload = '' --empty inputload before execution of pcall. pcall can break (rare case, can for example be provoked with metatable.__tostring = {}), which would corrupt future console inputs.
        --manually catch case, where the input did not define a proper Lua statement (i.e. loadfunc is nil)
        local results = loadedFunc and table.pack(xpcall(loadedFunc, self.errorHandler)) or {false, "Input is not a valid Lua-statement: " .. errorMsg}
        --output error message (unsuccessful case) or return values (successful case)
        if not results[1] then --results[1] is the error status that pcall always returns. False stands for: error occured.
            self:out('error', 0, true, results[2]) -- second result of pcall is the error message in case an error occured
        elseif results.n > 1 then --Check, if there was at least one valid output argument. We check results.n instead of results[2], because we also get nil as a proper return value this way.
            self:out('returnValue', 0, true, table.unpack(results, 2, results.n))
        end
    end
end

----------------------
--|      Out       |--
----------------------

-- split color codes, split linebreaks, print lines separately, print load-errors, update string width, update text, error handling with stack trace.

---Duplicates Color coding around linebreaks to make each line printable separately.
---Operates incorrectly on lookalike color codes invalidated by preceeding escaped vertical bar (like "||cffffcc00bla|r").
---Also operates incorrectly on multiple color codes, where the first is missing the end sequence (like "|cffffcc00Hello |cff0000ffWorld|r")
---@param inputString string
---@return string, integer
function IngameConsole.spreadColorCodes(inputString)
    local replacementTable = {} --remembers all substrings to be replaced and their replacements.
    for foundInstance, color in inputString:gmatch("((|c\x25x\x25x\x25x\x25x\x25x\x25x\x25x\x25x).-|r)") do
        replacementTable[foundInstance] = foundInstance:gsub("(\r?\n)", "|r\x251" .. color)
    end
    return inputString:gsub("((|c\x25x\x25x\x25x\x25x\x25x\x25x\x25x\x25x).-|r)", replacementTable)
end

---Concatenates all inputs to one string, spreads color codes around line breaks and prints each line to the console separately.
---@param colorTheme? '"timestamp"'| '"singleLineInput"' | '"multiLineInput"' | '"result"' | '"keywordInput"' | '"info"' | '"error"' | '"returnValue"' Decides about the color to be applied. Currently accepted: 'timestamp', 'singleLineInput', 'multiLineInput', 'result', nil. (nil equals no colorTheme, i.e. white color)
---@param numIndentations integer Number of '>' chars that shall preceed the output
---@param hideTimestamp boolean Set to false to hide the timestamp column and instead show a "->" symbol.
---@param ... any the things to be printed in the console.
function IngameConsole:out(colorTheme, numIndentations, hideTimestamp, ...)
    local inputs = table.pack(...)
    for i = 1, inputs.n do
        inputs[i] = tostring(inputs[i]) --apply tostring on every input param in preparation for table.concat
    end
    --Concatenate all inputs (4-space-separated)
    local printOutput = table.concat(inputs, '    ', 1, inputs.n)
    printOutput = printOutput:find("(\r?\n)") and IngameConsole.spreadColorCodes(printOutput) or printOutput
    local substrStart, substrEnd = 1, 1
    local numLinebreaks, completePrint = 0, true
    repeat
        substrEnd = (printOutput:find("(\r?\n)", substrStart) or 0) - 1
        numLinebreaks, completePrint = self:lineOut(colorTheme, numIndentations, hideTimestamp, numLinebreaks, printOutput:sub(substrStart, substrEnd))
        hideTimestamp = true
        substrStart = substrEnd + 2
    until substrEnd == -1 or numLinebreaks > self.maxLinebreaks
    if substrEnd ~= -1 or not completePrint then
        self:lineOut('info', 0, false, 0, "Previous value not entirely printed after exceeding maximum number of linebreaks. Consider adjusting 'IngameConsole.maxLinebreaks'.")
    end
    self:updateMultiboard()
end

---Prints the given string to the console with the specified colorTheme and the specified number of indentations.
---Only supports one-liners (no \n) due to how multiboards work. Will add linebreaks though, if the one-liner doesn't fit into the given multiboard space.
---@param colorTheme? '"timestamp"'| '"singleLineInput"' | '"multiLineInput"' | '"result"' | '"keywordInput"' | '"info"' | '"error"' | '"returnValue"' Decides about the color to be applied. Currently accepted: 'timestamp', 'singleLineInput', 'multiLineInput', 'result', nil. (nil equals no colorTheme, i.e. white color)
---@param numIndentations integer Number of greater '>' chars that shall preceed the output
---@param hideTimestamp boolean Set to false to hide the timestamp column and instead show a "->" symbol.
---@param numLinebreaks integer
---@param printOutput string the line to be printed in the console.
---@return integer numLinebreaks, boolean hasPrintedEverything returns true, if everything could be printed. Returns false otherwise (can happen for very long strings).
function IngameConsole:lineOut(colorTheme, numIndentations, hideTimestamp, numLinebreaks, printOutput)
    --add preceeding greater chars
    printOutput = ('>'):rep(numIndentations) .. printOutput
    --Print a space instead of the empty string. This allows the console to identify, if the string has already been fully printed (see while-loop below).
    if printOutput == '' then
        printOutput = ' '
    end
    --Compute Linebreaks.
    local linebreakWidth = ((self.autosize and self.mainColMaxWidth) or self.currentWidth )
    local partialOutput = nil
    local maxPrintableCharPosition
    local printWidth
    while string.len(printOutput) > 0  and numLinebreaks <= self.maxLinebreaks do --break, if the input string has reached length 0 OR when the maximum number of linebreaks would be surpassed.
        --compute max printable substring (in one multiboard line)
        maxPrintableCharPosition, printWidth = IngameConsole.getLinebreakData(printOutput, linebreakWidth - self.linebreakBuffer, self.textLanguage)
        --adds timestamp to the first line of any output
        if numLinebreaks == 0 then
            partialOutput = printOutput:sub(1, numIndentations) .. ((IngameConsole.colors[colorTheme] and "|cff" .. IngameConsole.colors[colorTheme] .. printOutput:sub(numIndentations + 1, maxPrintableCharPosition) .. "|r") or printOutput:sub(numIndentations + 1, maxPrintableCharPosition)) --Colorize the output string, if a color theme was specified. IngameConsole.colors[colorTheme] can be nil.
            table.insert(self.outputTimestamps, "|cff" .. IngameConsole.colors['timestamp'] .. ((hideTimestamp and '            ->') or IngameConsole.formatTimerElapsed(TimerGetElapsed(self.timer))) .. "|r")
        else
            partialOutput = (IngameConsole.colors[colorTheme] and "|cff" .. IngameConsole.colors[colorTheme] .. printOutput:sub(1, maxPrintableCharPosition) .. "|r") or printOutput:sub(1, maxPrintableCharPosition) --Colorize the output string, if a color theme was specified. IngameConsole.colors[colorTheme] can be nil.
            table.insert(self.outputTimestamps, '            ..') --need a dummy entry in the timestamp list to make it line-progress with the normal output.
        end
        numLinebreaks = numLinebreaks + 1
        --writes output string and width to the console tables.
        table.insert(self.output, partialOutput)
        table.insert(self.outputWidths, printWidth + self.linebreakBuffer) --remember the Width of this printed string to adjust the multiboard size in case. 0.5 percent is added to avoid the case, where the multiboard width is too small by a tiny bit, thus not showing some string without spaces.
        --compute remaining string to print
        printOutput = string.sub(printOutput, maxPrintableCharPosition + 1, -1) --remaining string until the end. Returns empty string, if there is nothing left
    end
    self.currentLine = #self.output
    return numLinebreaks, string.len(printOutput) == 0 --printOutput is the empty string, if and only if everything has been printed
end

---Lets the multiboard show the recently printed lines.
function IngameConsole:updateMultiboard()
    local startIndex = math.max(self.currentLine - self.numRows, 0) --to be added to loop counter to get to the index of output table to print
    local outputIndex = 0
    local maxWidth = 0.
    local mbitem
    for i = 1, self.numRows do --doesn't include title row (index 0)
        outputIndex = i + startIndex
        mbitem = MultiboardGetItem(self.multiboard, i, 0)
        MultiboardSetItemValue(mbitem, self.outputTimestamps[outputIndex] or '')
        MultiboardReleaseItem(mbitem)
        mbitem = MultiboardGetItem(self.multiboard, i, 1)
        MultiboardSetItemValue(mbitem, self.output[outputIndex] or '')
        MultiboardReleaseItem(mbitem)
        maxWidth = math.max(maxWidth, self.outputWidths[outputIndex] or 0.) --looping through non-defined widths, so need to coalesce with 0
    end
    --Adjust Multiboard Width, if necessary.
    maxWidth = math.min(math.max(maxWidth, self.mainColMinWidth), self.mainColMaxWidth)
    if self.autosize and self.currentWidth ~= maxWidth then
        self.currentWidth = maxWidth
        for i = 1, self.numRows +1 do
            mbitem = MultiboardGetItem(self.multiboard, i-1, 1)
            MultiboardSetItemWidth(mbitem, maxWidth)
            MultiboardReleaseItem(mbitem)
        end
        self:showToOwners() --reshow multiboard to update item widths on the frontend
    end
end

---Shows the multiboard to all owners (one or all players)
function IngameConsole:showToOwners()
    if self.sharedConsole or GetLocalPlayer() == self.player then
        MultiboardDisplay(self.multiboard, true)
        MultiboardMinimize(self.multiboard, false)
    end
end

---Formats the elapsed time as "mm: ss. hh" (h being a hundreds of a sec)
function IngameConsole.formatTimerElapsed(elapsedInSeconds)
    return string.format("\x2502d: \x2502.f. \x2502.f", elapsedInSeconds // 60, math.fmod(elapsedInSeconds, 60.) // 1, math.fmod(elapsedInSeconds, 1) * 100)
end

---Computes the max printable substring for a given string and a given linebreakWidth (regarding a single line of console).
---Returns both the substrings last char position and its total width in the multiboard.
---@param stringToPrint string the string supposed to be printed in the multiboard console.
---@param linebreakWidth number the maximum allowed width in one line of the console, before a string must linebreak
---@param textLanguage string 'ger' or 'eng'
---@return integer maxPrintableCharPosition, number printWidth
function IngameConsole.getLinebreakData(stringToPrint, linebreakWidth, textLanguage)
    local loopWidth = 0.
    local bytecodes = table.pack(string.byte(stringToPrint, 1, -1))
    for i = 1, bytecodes.n do
        loopWidth = loopWidth + string.charMultiboardWidth(bytecodes[i], textLanguage)
        if loopWidth > linebreakWidth then
            return i-1, loopWidth - string.charMultiboardWidth(bytecodes[i], textLanguage)
        end
    end
    return bytecodes.n, loopWidth
end

-------------------------
--| Reserved Keywords |--
-------------------------

---Exits the Console
---@param self IngameConsole
function IngameConsole.keywords.exit(self)
    DestroyMultiboard(self.multiboard)
    DestroyTrigger(self.trigger)
    DestroyTimer(self.timer)
    IngameConsole.playerConsoles[self.player] = nil
    if next(IngameConsole.playerConsoles) == nil then --set print function back to original, when no one has an active console left.
        print = IngameConsole.originalPrint
    end
end

---Lets the console print to chat
---@param self IngameConsole
function IngameConsole.keywords.printtochat(self)
    self.printToConsole = false
    self:out('info', 0, false, "The print function will print to the normal chat.")
end

---Lets the console print to itself (default)
---@param self IngameConsole
function IngameConsole.keywords.printtoconsole(self)
    self.printToConsole = true
    self:out('info', 0, false, "The print function will print to the console.")
end

---Shows the console in case it was hidden by another multiboard before
---@param self IngameConsole
function IngameConsole.keywords.show(self)
    self:showToOwners() --might be necessary to do, if another multiboard has shown up and thereby hidden the console.
    self:out('info', 0, false, "Console is showing.")
end

---Prints all available reserved keywords plus explanations.
---@param self IngameConsole
function IngameConsole.keywords.help(self)
    self:out('info', 0, false, "The Console currently reserves the following keywords:")
    self:out('info', 0, false, "'help' shows the text you are currently reading.")
    self:out('info', 0, false, "'exit' closes the console.")
    self:out('info', 0, false, "'lasttrace' shows the stack trace of the latest error that occured within IngameConsole.")
    self:out('info', 0, false, "'share' allows other players to read and write into your console, but also force-closes their own consoles.")
    self:out('info', 0, false, "'clear' clears all text from the console.")
    self:out('info', 0, false, "'show' shows the console. Sensible to use, when displaced by another multiboard.")
    self:out('info', 0, false, "'printtochat' lets Wc3 print text to normal chat again.")
    self:out('info', 0, false, "'printtoconsole' lets Wc3 print text to the console (default).")
    self:out('info', 0, false, "'autosize on' enables automatic console resize depending on the longest line in the display.")
    self:out('info', 0, false, "'autosize off' retains the current console size.")
    self:out('info', 0, false, "'textlang eng' will use english text installation font size to compute linebreaks (default).")
    self:out('info', 0, false, "'textlang ger' will use german text installation font size to compute linebreaks.")
    self:out('info', 0, false, "Preceeding a line with '>' prevents immediate execution, until a line not starting with '>' has been entered.")
end

---Clears the display of the console.
---@param self IngameConsole
function IngameConsole.keywords.clear(self)
    self.output = {}
    self.outputTimestamps = {}
    self.outputWidths = {}
    self.currentLine = 0
    self:out('keywordInput', 1, false, 'clear') --we print 'clear' again. The keyword was already printed by self:processInput, but cleared immediately after.
end

---Shares the console with other players in the same game.
---@param self IngameConsole
function IngameConsole.keywords.share(self)
    for _, console in pairs(IngameConsole.playerConsoles) do
        if console ~= self then
            IngameConsole.keywords['exit'](console) --share was triggered during console runtime, so there potentially are active consoles of others players that need to exit.
        end
    end
    self:makeShared()
    self:showToOwners() --showing it to the other players.
    self:out('info', 0,false, "The console of player " .. GetConvertedPlayerId(self.player) .. " is now shared with all players.")
end

---Enables auto-sizing of console (will grow and shrink together with text size)
---@param self IngameConsole
IngameConsole.keywords["autosize on"] = function(self)
    self.autosize = true
    self:out('info', 0,false, "The console will now change size depending on its content.")
end

---Disables auto-sizing of console
---@param self IngameConsole
IngameConsole.keywords["autosize off"] = function(self)
    self.autosize = false
    self:out('info', 0,false, "The console will retain the width that it currently has.")
end

---Lets linebreaks be computed by german font size
---@param self IngameConsole
IngameConsole.keywords["textlang ger"] = function(self)
    self.textLanguage = 'ger'
    self:out('info', 0,false, "Linebreaks will now compute with respect to german text installation font size.")
end

---Lets linebreaks be computed by english font size
---@param self IngameConsole
IngameConsole.keywords["textlang eng"] = function(self)
    self.textLanguage = 'eng'
    self:out('info', 0,false, "Linebreaks will now compute with respect to english text installation font size.")
end

---Prints the stack trace of the latest error that occured within IngameConsole.
---@param self IngameConsole
IngameConsole.keywords["lasttrace"] = function(self)
    self:out('error', 0,false, self.lastTrace)
end

--------------------
--| Main Trigger |--
--------------------

do
    --Actions to be executed upon typing -exec
    local function execCommand_Actions()
        local input = string.sub(GetEventPlayerChatString(),7,-1)
        print("Executing input: |cffffff44" .. input .. "|r")
        --try preceeding the input by a return statement (preparation for printing below)
        local loadedFunc, errorMsg = load("return ".. input)
        if not loadedFunc then --if that doesn't produce valid code, try without return statement
            loadedFunc, errorMsg = load(input)
        end
        --execute loaded function in case the string defined a valid function. Otherwise print error.
        if errorMsg then
            print("|cffff5555Invalid Lua-statement: " .. Debug.getLocalErrorMsg(errorMsg) .. "|r")
        else
            ---@diagnostic disable-next-line: param-type-mismatch
            local results = table.pack(Debug.try(loadedFunc))
            if results[1] ~= nil or results.n > 1 then
                for i = 1, results.n do
                    results[i] = tostring(results[i])
                end
                --concatenate all function return values to one colorized string
                print("|cff00ffff" .. table.concat(results, '    ', 1, results.n) .. "|r")
            end
        end
    end

    local function execCommand_Condition()
        return string.sub(GetEventPlayerChatString(), 1, 6) == "-exec "
    end

    local function startIngameConsole()
        --if the triggering player already has a console, show that console and stop executing further actions
        if IngameConsole.playerConsoles[GetTriggerPlayer()] then
            IngameConsole.playerConsoles[GetTriggerPlayer()]:showToOwners()
            return
        end
        --create Ingame Console object
        IngameConsole.playerConsoles[GetTriggerPlayer()] = IngameConsole.create(GetTriggerPlayer())
        --overwrite print function
        print = function(...)
            IngameConsole.originalPrint(...) --the new print function will also print "normally", but clear the text immediately after. This is to add the message to the F12-log.
            if IngameConsole.playerConsoles[GetLocalPlayer()] and IngameConsole.playerConsoles[GetLocalPlayer()].printToConsole then
                ClearTextMessages() --clear text messages for all players having an active console
            end
            for player, console in pairs(IngameConsole.playerConsoles) do
                if console.printToConsole and (player == console.player) then --player == console.player ensures that the console only prints once, even if the console was shared among all players
                    console:out(nil, 0, false, ...)
                end
            end
        end
    end

    ---Creates the triggers listening to "-console" and "-exec" chat input.
    ---Being executed within DebugUtils (MarkGameStart overwrite).
    function IngameConsole.createTriggers()
        --Exec
        local execTrigger = CreateTrigger()
        TriggerAddCondition(execTrigger, Condition(execCommand_Condition))
        TriggerAddAction(execTrigger, execCommand_Actions)
        --Real Console
        local consoleTrigger = CreateTrigger()
        TriggerAddAction(consoleTrigger, startIngameConsole)
        --Events
        for i = 0, GetBJMaxPlayers() -1 do
            TriggerRegisterPlayerChatEvent(execTrigger, Player(i), "-exec ", false)
            TriggerRegisterPlayerChatEvent(consoleTrigger, Player(i), "-console", true)
        end
    end
end

--[[
    used by Ingame Console to determine multiboard size
    every unknown char will be treated as having default width (see constants below)
--]]

do
    ----------------------------
    ----| String Width API |----
    ----------------------------

    local multiboardCharTable = {}                        ---@type table  -- saves the width in screen percent (on 1920 pixel width resolutions) that each char takes up, when displayed in a multiboard.
    local DEFAULT_MULTIBOARD_CHAR_WIDTH = 1. / 128.        ---@type number    -- used for unknown chars (where we didn't define a width in the char table)
    local MULTIBOARD_TO_PRINT_FACTOR = 1. / 36.            ---@type number    -- 36 is actually the lower border (longest width of a non-breaking string only consisting of the letter "i")

    ---Returns the width of a char in a multiboard, when inputting a char (string of length 1) and 0 otherwise.
    ---also returns 0 for non-recorded chars (like ` and ´ and ß and § and €)
    ---@param char string | integer integer bytecode representations of chars are also allowed, i.e. the results of string.byte().
    ---@param textlanguage? '"ger"'| '"eng"' (default: 'eng'), depending on the text language in the Warcraft 3 installation settings.
    ---@return number
    function string.charMultiboardWidth(char, textlanguage)
        return multiboardCharTable[textlanguage or 'eng'][char] or DEFAULT_MULTIBOARD_CHAR_WIDTH
    end

    ---returns the width of a string in a multiboard (i.e. output is in screen percent)
    ---unknown chars will be measured with default width (see constants above)
    ---@param multichar string
    ---@param textlanguage? '"ger"'| '"eng"' (default: 'eng'), depending on the text language in the Warcraft 3 installation settings.
    ---@return number
    function string.multiboardWidth(multichar, textlanguage)
        local chartable = table.pack(multichar:byte(1,-1)) --packs all bytecode char representations into a table
        local charWidth = 0.
        for i = 1, chartable.n do
            charWidth = charWidth + string.charMultiboardWidth(chartable[i], textlanguage)
        end
        return charWidth
    end

    ---The function should match the following criteria: If the value returned by this function is smaller than 1.0, than the string fits into a single line on screen.
    ---The opposite is not necessarily true (but should be true in the majority of cases): If the function returns bigger than 1.0, the string doesn't necessarily break.
    ---@param char string | integer integer bytecode representations of chars are also allowed, i.e. the results of string.byte().
    ---@param textlanguage? '"ger"'| '"eng"' (default: 'eng'), depending on the text language in the Warcraft 3 installation settings.
    ---@return number
    function string.charPrintWidth(char, textlanguage)
        return string.charMultiboardWidth(char, textlanguage) * MULTIBOARD_TO_PRINT_FACTOR
    end

    ---The function should match the following criteria: If the value returned by this function is smaller than 1.0, than the string fits into a single line on screen.
    ---The opposite is not necessarily true (but should be true in the majority of cases): If the function returns bigger than 1.0, the string doesn't necessarily break.
    ---@param multichar string
    ---@param textlanguage? '"ger"'| '"eng"' (default: 'eng'), depending on the text language in the Warcraft 3 installation settings.
    ---@return number
    function string.printWidth(multichar, textlanguage)
        return string.multiboardWidth(multichar, textlanguage) * MULTIBOARD_TO_PRINT_FACTOR
    end

    ----------------------------------
    ----| String Width Internals |----
    ----------------------------------

    ---@param charset '"ger"'| '"eng"' (default: 'eng'), depending on the text language in the Warcraft 3 installation settings.
    ---@param char string|integer either the char or its bytecode
    ---@param lengthInScreenWidth number
    local function setMultiboardCharWidth(charset, char, lengthInScreenWidth)
        multiboardCharTable[charset] = multiboardCharTable[charset] or {}
        multiboardCharTable[charset][char] = lengthInScreenWidth
    end

    ---numberPlacements says how often the char can be placed in a multiboard column, before reaching into the right bound.
    ---@param charset '"ger"'| '"eng"' (default: 'eng'), depending on the text language in the Warcraft 3 installation settings.
    ---@param char string|integer either the char or its bytecode
    ---@param numberPlacements integer
    local function setMultiboardCharWidthBase80(charset, char, numberPlacements)
        setMultiboardCharWidth(charset, char, 0.8 / numberPlacements) --1-based measure. 80./numberPlacements would result in Screen Percent.
        setMultiboardCharWidth(charset, char:byte(1,-1), 0.8 / numberPlacements)
    end

    -- Set Char Width for all printable ascii chars in screen width (1920 pixels). Measured on a 80percent screen width multiboard column by counting the number of chars that fit into it.
    -- Font size differs by text install language and patch (1.32- vs. 1.33+)
    if BlzGetUnitOrderCount then --identifies patch 1.33+
        --German font size for patch 1.33+
        setMultiboardCharWidthBase80('ger', "a", 144)
        setMultiboardCharWidthBase80('ger', "b", 131)
        setMultiboardCharWidthBase80('ger', "c", 144)
        setMultiboardCharWidthBase80('ger', "d", 120)
        setMultiboardCharWidthBase80('ger', "e", 131)
        setMultiboardCharWidthBase80('ger', "f", 240)
        setMultiboardCharWidthBase80('ger', "g", 120)
        setMultiboardCharWidthBase80('ger', "h", 131)
        setMultiboardCharWidthBase80('ger', "i", 288)
        setMultiboardCharWidthBase80('ger', "j", 288)
        setMultiboardCharWidthBase80('ger', "k", 144)
        setMultiboardCharWidthBase80('ger', "l", 288)
        setMultiboardCharWidthBase80('ger', "m", 85)
        setMultiboardCharWidthBase80('ger', "n", 131)
        setMultiboardCharWidthBase80('ger', "o", 120)
        setMultiboardCharWidthBase80('ger', "p", 120)
        setMultiboardCharWidthBase80('ger', "q", 120)
        setMultiboardCharWidthBase80('ger', "r", 206)
        setMultiboardCharWidthBase80('ger', "s", 160)
        setMultiboardCharWidthBase80('ger', "t", 206)
        setMultiboardCharWidthBase80('ger', "u", 131)
        setMultiboardCharWidthBase80('ger', "v", 131)
        setMultiboardCharWidthBase80('ger', "w", 96)
        setMultiboardCharWidthBase80('ger', "x", 144)
        setMultiboardCharWidthBase80('ger', "y", 131)
        setMultiboardCharWidthBase80('ger', "z", 144)
        setMultiboardCharWidthBase80('ger', "A", 103)
        setMultiboardCharWidthBase80('ger', "B", 120)
        setMultiboardCharWidthBase80('ger', "C", 111)
        setMultiboardCharWidthBase80('ger', "D", 103)
        setMultiboardCharWidthBase80('ger', "E", 144)
        setMultiboardCharWidthBase80('ger', "F", 160)
        setMultiboardCharWidthBase80('ger', "G", 96)
        setMultiboardCharWidthBase80('ger', "H", 96)
        setMultiboardCharWidthBase80('ger', "I", 240)
        setMultiboardCharWidthBase80('ger', "J", 240)
        setMultiboardCharWidthBase80('ger', "K", 120)
        setMultiboardCharWidthBase80('ger', "L", 144)
        setMultiboardCharWidthBase80('ger', "M", 76)
        setMultiboardCharWidthBase80('ger', "N", 96)
        setMultiboardCharWidthBase80('ger', "O", 90)
        setMultiboardCharWidthBase80('ger', "P", 131)
        setMultiboardCharWidthBase80('ger', "Q", 90)
        setMultiboardCharWidthBase80('ger', "R", 120)
        setMultiboardCharWidthBase80('ger', "S", 131)
        setMultiboardCharWidthBase80('ger', "T", 144)
        setMultiboardCharWidthBase80('ger', "U", 103)
        setMultiboardCharWidthBase80('ger', "V", 120)
        setMultiboardCharWidthBase80('ger', "W", 76)
        setMultiboardCharWidthBase80('ger', "X", 111)
        setMultiboardCharWidthBase80('ger', "Y", 120)
        setMultiboardCharWidthBase80('ger', "Z", 120)
        setMultiboardCharWidthBase80('ger', "1", 144)
        setMultiboardCharWidthBase80('ger', "2", 120)
        setMultiboardCharWidthBase80('ger', "3", 120)
        setMultiboardCharWidthBase80('ger', "4", 120)
        setMultiboardCharWidthBase80('ger', "5", 120)
        setMultiboardCharWidthBase80('ger', "6", 120)
        setMultiboardCharWidthBase80('ger', "7", 131)
        setMultiboardCharWidthBase80('ger', "8", 120)
        setMultiboardCharWidthBase80('ger', "9", 120)
        setMultiboardCharWidthBase80('ger', "0", 120)
        setMultiboardCharWidthBase80('ger', ":", 288)
        setMultiboardCharWidthBase80('ger', ";", 288)
        setMultiboardCharWidthBase80('ger', ".", 288)
        setMultiboardCharWidthBase80('ger', "#", 120)
        setMultiboardCharWidthBase80('ger', ",", 288)
        setMultiboardCharWidthBase80('ger', " ", 286) --space
        setMultiboardCharWidthBase80('ger', "'", 180)
        setMultiboardCharWidthBase80('ger', "!", 180)
        setMultiboardCharWidthBase80('ger', "$", 131)
        setMultiboardCharWidthBase80('ger', "&", 90)
        setMultiboardCharWidthBase80('ger', "/", 180)
        setMultiboardCharWidthBase80('ger', "(", 240)
        setMultiboardCharWidthBase80('ger', ")", 240)
        setMultiboardCharWidthBase80('ger', "=", 120)
        setMultiboardCharWidthBase80('ger', "?", 144)
        setMultiboardCharWidthBase80('ger', "^", 144)
        setMultiboardCharWidthBase80('ger', "<", 144)
        setMultiboardCharWidthBase80('ger', ">", 144)
        setMultiboardCharWidthBase80('ger', "-", 180)
        setMultiboardCharWidthBase80('ger', "+", 120)
        setMultiboardCharWidthBase80('ger', "*", 180)
        setMultiboardCharWidthBase80('ger', "|", 287) --2 vertical bars in a row escape to one. So you could print 960 ones in a line, 480 would display. Maybe need to adapt to this before calculating string width.
        setMultiboardCharWidthBase80('ger', "~", 111)
        setMultiboardCharWidthBase80('ger', "{", 240)
        setMultiboardCharWidthBase80('ger', "}", 240)
        setMultiboardCharWidthBase80('ger', "[", 240)
        setMultiboardCharWidthBase80('ger', "]", 240)
        setMultiboardCharWidthBase80('ger', "_", 144)
        setMultiboardCharWidthBase80('ger', "\x25", 103) --percent
        setMultiboardCharWidthBase80('ger', "\x5C", 205) --backslash
        setMultiboardCharWidthBase80('ger', "\x22", 120) --double quotation mark
        setMultiboardCharWidthBase80('ger', "\x40", 90) --at sign
        setMultiboardCharWidthBase80('ger', "\x60", 144) --Gravis (Accent)

        --English font size for patch 1.33+
        setMultiboardCharWidthBase80('eng', "a", 144)
        setMultiboardCharWidthBase80('eng', "b", 120)
        setMultiboardCharWidthBase80('eng', "c", 131)
        setMultiboardCharWidthBase80('eng', "d", 120)
        setMultiboardCharWidthBase80('eng', "e", 120)
        setMultiboardCharWidthBase80('eng', "f", 240)
        setMultiboardCharWidthBase80('eng', "g", 120)
        setMultiboardCharWidthBase80('eng', "h", 120)
        setMultiboardCharWidthBase80('eng', "i", 288)
        setMultiboardCharWidthBase80('eng', "j", 288)
        setMultiboardCharWidthBase80('eng', "k", 144)
        setMultiboardCharWidthBase80('eng', "l", 288)
        setMultiboardCharWidthBase80('eng', "m", 80)
        setMultiboardCharWidthBase80('eng', "n", 120)
        setMultiboardCharWidthBase80('eng', "o", 111)
        setMultiboardCharWidthBase80('eng', "p", 111)
        setMultiboardCharWidthBase80('eng', "q", 111)
        setMultiboardCharWidthBase80('eng', "r", 206)
        setMultiboardCharWidthBase80('eng', "s", 160)
        setMultiboardCharWidthBase80('eng', "t", 206)
        setMultiboardCharWidthBase80('eng', "u", 120)
        setMultiboardCharWidthBase80('eng', "v", 144)
        setMultiboardCharWidthBase80('eng', "w", 90)
        setMultiboardCharWidthBase80('eng', "x", 131)
        setMultiboardCharWidthBase80('eng', "y", 144)
        setMultiboardCharWidthBase80('eng', "z", 144)
        setMultiboardCharWidthBase80('eng', "A", 103)
        setMultiboardCharWidthBase80('eng', "B", 120)
        setMultiboardCharWidthBase80('eng', "C", 103)
        setMultiboardCharWidthBase80('eng', "D", 96)
        setMultiboardCharWidthBase80('eng', "E", 131)
        setMultiboardCharWidthBase80('eng', "F", 160)
        setMultiboardCharWidthBase80('eng', "G", 96)
        setMultiboardCharWidthBase80('eng', "H", 90)
        setMultiboardCharWidthBase80('eng', "I", 240)
        setMultiboardCharWidthBase80('eng', "J", 240)
        setMultiboardCharWidthBase80('eng', "K", 120)
        setMultiboardCharWidthBase80('eng', "L", 131)
        setMultiboardCharWidthBase80('eng', "M", 76)
        setMultiboardCharWidthBase80('eng', "N", 90)
        setMultiboardCharWidthBase80('eng', "O", 85)
        setMultiboardCharWidthBase80('eng', "P", 120)
        setMultiboardCharWidthBase80('eng', "Q", 85)
        setMultiboardCharWidthBase80('eng', "R", 120)
        setMultiboardCharWidthBase80('eng', "S", 131)
        setMultiboardCharWidthBase80('eng', "T", 144)
        setMultiboardCharWidthBase80('eng', "U", 96)
        setMultiboardCharWidthBase80('eng', "V", 120)
        setMultiboardCharWidthBase80('eng', "W", 76)
        setMultiboardCharWidthBase80('eng', "X", 111)
        setMultiboardCharWidthBase80('eng', "Y", 120)
        setMultiboardCharWidthBase80('eng', "Z", 111)
        setMultiboardCharWidthBase80('eng', "1", 103)
        setMultiboardCharWidthBase80('eng', "2", 111)
        setMultiboardCharWidthBase80('eng', "3", 111)
        setMultiboardCharWidthBase80('eng', "4", 111)
        setMultiboardCharWidthBase80('eng', "5", 111)
        setMultiboardCharWidthBase80('eng', "6", 111)
        setMultiboardCharWidthBase80('eng', "7", 111)
        setMultiboardCharWidthBase80('eng', "8", 111)
        setMultiboardCharWidthBase80('eng', "9", 111)
        setMultiboardCharWidthBase80('eng', "0", 111)
        setMultiboardCharWidthBase80('eng', ":", 288)
        setMultiboardCharWidthBase80('eng', ";", 288)
        setMultiboardCharWidthBase80('eng', ".", 288)
        setMultiboardCharWidthBase80('eng', "#", 103)
        setMultiboardCharWidthBase80('eng', ",", 288)
        setMultiboardCharWidthBase80('eng', " ", 286) --space
        setMultiboardCharWidthBase80('eng', "'", 360)
        setMultiboardCharWidthBase80('eng', "!", 288)
        setMultiboardCharWidthBase80('eng', "$", 131)
        setMultiboardCharWidthBase80('eng', "&", 120)
        setMultiboardCharWidthBase80('eng', "/", 180)
        setMultiboardCharWidthBase80('eng', "(", 206)
        setMultiboardCharWidthBase80('eng', ")", 206)
        setMultiboardCharWidthBase80('eng', "=", 111)
        setMultiboardCharWidthBase80('eng', "?", 180)
        setMultiboardCharWidthBase80('eng', "^", 144)
        setMultiboardCharWidthBase80('eng', "<", 111)
        setMultiboardCharWidthBase80('eng', ">", 111)
        setMultiboardCharWidthBase80('eng', "-", 160)
        setMultiboardCharWidthBase80('eng', "+", 111)
        setMultiboardCharWidthBase80('eng', "*", 144)
        setMultiboardCharWidthBase80('eng', "|", 479) --2 vertical bars in a row escape to one. So you could print 960 ones in a line, 480 would display. Maybe need to adapt to this before calculating string width.
        setMultiboardCharWidthBase80('eng', "~", 144)
        setMultiboardCharWidthBase80('eng', "{", 160)
        setMultiboardCharWidthBase80('eng', "}", 160)
        setMultiboardCharWidthBase80('eng', "[", 206)
        setMultiboardCharWidthBase80('eng', "]", 206)
        setMultiboardCharWidthBase80('eng', "_", 120)
        setMultiboardCharWidthBase80('eng', "\x25", 103) --percent
        setMultiboardCharWidthBase80('eng', "\x5C", 180) --backslash
        setMultiboardCharWidthBase80('eng', "\x22", 180) --double quotation mark
        setMultiboardCharWidthBase80('eng', "\x40", 85) --at sign
        setMultiboardCharWidthBase80('eng', "\x60", 206) --Gravis (Accent)
    else
        --German font size up to patch 1.32
        setMultiboardCharWidthBase80('ger', "a", 144)
        setMultiboardCharWidthBase80('ger', "b", 144)
        setMultiboardCharWidthBase80('ger', "c", 144)
        setMultiboardCharWidthBase80('ger', "d", 131)
        setMultiboardCharWidthBase80('ger', "e", 144)
        setMultiboardCharWidthBase80('ger', "f", 240)
        setMultiboardCharWidthBase80('ger', "g", 120)
        setMultiboardCharWidthBase80('ger', "h", 144)
        setMultiboardCharWidthBase80('ger', "i", 360)
        setMultiboardCharWidthBase80('ger', "j", 288)
        setMultiboardCharWidthBase80('ger', "k", 144)
        setMultiboardCharWidthBase80('ger', "l", 360)
        setMultiboardCharWidthBase80('ger', "m", 90)
        setMultiboardCharWidthBase80('ger', "n", 144)
        setMultiboardCharWidthBase80('ger', "o", 131)
        setMultiboardCharWidthBase80('ger', "p", 131)
        setMultiboardCharWidthBase80('ger', "q", 131)
        setMultiboardCharWidthBase80('ger', "r", 206)
        setMultiboardCharWidthBase80('ger', "s", 180)
        setMultiboardCharWidthBase80('ger', "t", 206)
        setMultiboardCharWidthBase80('ger', "u", 144)
        setMultiboardCharWidthBase80('ger', "v", 131)
        setMultiboardCharWidthBase80('ger', "w", 96)
        setMultiboardCharWidthBase80('ger', "x", 144)
        setMultiboardCharWidthBase80('ger', "y", 131)
        setMultiboardCharWidthBase80('ger', "z", 144)
        setMultiboardCharWidthBase80('ger', "A", 103)
        setMultiboardCharWidthBase80('ger', "B", 131)
        setMultiboardCharWidthBase80('ger', "C", 120)
        setMultiboardCharWidthBase80('ger', "D", 111)
        setMultiboardCharWidthBase80('ger', "E", 144)
        setMultiboardCharWidthBase80('ger', "F", 180)
        setMultiboardCharWidthBase80('ger', "G", 103)
        setMultiboardCharWidthBase80('ger', "H", 103)
        setMultiboardCharWidthBase80('ger', "I", 288)
        setMultiboardCharWidthBase80('ger', "J", 240)
        setMultiboardCharWidthBase80('ger', "K", 120)
        setMultiboardCharWidthBase80('ger', "L", 144)
        setMultiboardCharWidthBase80('ger', "M", 80)
        setMultiboardCharWidthBase80('ger', "N", 103)
        setMultiboardCharWidthBase80('ger', "O", 96)
        setMultiboardCharWidthBase80('ger', "P", 144)
        setMultiboardCharWidthBase80('ger', "Q", 90)
        setMultiboardCharWidthBase80('ger', "R", 120)
        setMultiboardCharWidthBase80('ger', "S", 144)
        setMultiboardCharWidthBase80('ger', "T", 144)
        setMultiboardCharWidthBase80('ger', "U", 111)
        setMultiboardCharWidthBase80('ger', "V", 120)
        setMultiboardCharWidthBase80('ger', "W", 76)
        setMultiboardCharWidthBase80('ger', "X", 111)
        setMultiboardCharWidthBase80('ger', "Y", 120)
        setMultiboardCharWidthBase80('ger', "Z", 120)
        setMultiboardCharWidthBase80('ger', "1", 288)
        setMultiboardCharWidthBase80('ger', "2", 131)
        setMultiboardCharWidthBase80('ger', "3", 144)
        setMultiboardCharWidthBase80('ger', "4", 120)
        setMultiboardCharWidthBase80('ger', "5", 144)
        setMultiboardCharWidthBase80('ger', "6", 131)
        setMultiboardCharWidthBase80('ger', "7", 144)
        setMultiboardCharWidthBase80('ger', "8", 131)
        setMultiboardCharWidthBase80('ger', "9", 131)
        setMultiboardCharWidthBase80('ger', "0", 131)
        setMultiboardCharWidthBase80('ger', ":", 480)
        setMultiboardCharWidthBase80('ger', ";", 360)
        setMultiboardCharWidthBase80('ger', ".", 480)
        setMultiboardCharWidthBase80('ger', "#", 120)
        setMultiboardCharWidthBase80('ger', ",", 360)
        setMultiboardCharWidthBase80('ger', " ", 288) --space
        setMultiboardCharWidthBase80('ger', "'", 480)
        setMultiboardCharWidthBase80('ger', "!", 360)
        setMultiboardCharWidthBase80('ger', "$", 160)
        setMultiboardCharWidthBase80('ger', "&", 96)
        setMultiboardCharWidthBase80('ger', "/", 180)
        setMultiboardCharWidthBase80('ger', "(", 288)
        setMultiboardCharWidthBase80('ger', ")", 288)
        setMultiboardCharWidthBase80('ger', "=", 160)
        setMultiboardCharWidthBase80('ger', "?", 180)
        setMultiboardCharWidthBase80('ger', "^", 144)
        setMultiboardCharWidthBase80('ger', "<", 160)
        setMultiboardCharWidthBase80('ger', ">", 160)
        setMultiboardCharWidthBase80('ger', "-", 144)
        setMultiboardCharWidthBase80('ger', "+", 160)
        setMultiboardCharWidthBase80('ger', "*", 206)
        setMultiboardCharWidthBase80('ger', "|", 480) --2 vertical bars in a row escape to one. So you could print 960 ones in a line, 480 would display. Maybe need to adapt to this before calculating string width.
        setMultiboardCharWidthBase80('ger', "~", 144)
        setMultiboardCharWidthBase80('ger', "{", 240)
        setMultiboardCharWidthBase80('ger', "}", 240)
        setMultiboardCharWidthBase80('ger', "[", 240)
        setMultiboardCharWidthBase80('ger', "]", 288)
        setMultiboardCharWidthBase80('ger', "_", 144)
        setMultiboardCharWidthBase80('ger', "\x25", 111) --percent
        setMultiboardCharWidthBase80('ger', "\x5C", 206) --backslash
        setMultiboardCharWidthBase80('ger', "\x22", 240) --double quotation mark
        setMultiboardCharWidthBase80('ger', "\x40", 103) --at sign
        setMultiboardCharWidthBase80('ger', "\x60", 240) --Gravis (Accent)

        --English Font size up to patch 1.32
        setMultiboardCharWidthBase80('eng', "a", 144)
        setMultiboardCharWidthBase80('eng', "b", 120)
        setMultiboardCharWidthBase80('eng', "c", 131)
        setMultiboardCharWidthBase80('eng', "d", 120)
        setMultiboardCharWidthBase80('eng', "e", 131)
        setMultiboardCharWidthBase80('eng', "f", 240)
        setMultiboardCharWidthBase80('eng', "g", 120)
        setMultiboardCharWidthBase80('eng', "h", 131)
        setMultiboardCharWidthBase80('eng', "i", 360)
        setMultiboardCharWidthBase80('eng', "j", 288)
        setMultiboardCharWidthBase80('eng', "k", 144)
        setMultiboardCharWidthBase80('eng', "l", 360)
        setMultiboardCharWidthBase80('eng', "m", 80)
        setMultiboardCharWidthBase80('eng', "n", 131)
        setMultiboardCharWidthBase80('eng', "o", 120)
        setMultiboardCharWidthBase80('eng', "p", 120)
        setMultiboardCharWidthBase80('eng', "q", 120)
        setMultiboardCharWidthBase80('eng', "r", 206)
        setMultiboardCharWidthBase80('eng', "s", 160)
        setMultiboardCharWidthBase80('eng', "t", 206)
        setMultiboardCharWidthBase80('eng', "u", 131)
        setMultiboardCharWidthBase80('eng', "v", 144)
        setMultiboardCharWidthBase80('eng', "w", 90)
        setMultiboardCharWidthBase80('eng', "x", 131)
        setMultiboardCharWidthBase80('eng', "y", 144)
        setMultiboardCharWidthBase80('eng', "z", 144)
        setMultiboardCharWidthBase80('eng', "A", 103)
        setMultiboardCharWidthBase80('eng', "B", 120)
        setMultiboardCharWidthBase80('eng', "C", 103)
        setMultiboardCharWidthBase80('eng', "D", 103)
        setMultiboardCharWidthBase80('eng', "E", 131)
        setMultiboardCharWidthBase80('eng', "F", 160)
        setMultiboardCharWidthBase80('eng', "G", 103)
        setMultiboardCharWidthBase80('eng', "H", 96)
        setMultiboardCharWidthBase80('eng', "I", 288)
        setMultiboardCharWidthBase80('eng', "J", 240)
        setMultiboardCharWidthBase80('eng', "K", 120)
        setMultiboardCharWidthBase80('eng', "L", 131)
        setMultiboardCharWidthBase80('eng', "M", 76)
        setMultiboardCharWidthBase80('eng', "N", 96)
        setMultiboardCharWidthBase80('eng', "O", 85)
        setMultiboardCharWidthBase80('eng', "P", 131)
        setMultiboardCharWidthBase80('eng', "Q", 85)
        setMultiboardCharWidthBase80('eng', "R", 120)
        setMultiboardCharWidthBase80('eng', "S", 131)
        setMultiboardCharWidthBase80('eng', "T", 144)
        setMultiboardCharWidthBase80('eng', "U", 103)
        setMultiboardCharWidthBase80('eng', "V", 120)
        setMultiboardCharWidthBase80('eng', "W", 76)
        setMultiboardCharWidthBase80('eng', "X", 111)
        setMultiboardCharWidthBase80('eng', "Y", 120)
        setMultiboardCharWidthBase80('eng', "Z", 111)
        setMultiboardCharWidthBase80('eng', "1", 206)
        setMultiboardCharWidthBase80('eng', "2", 131)
        setMultiboardCharWidthBase80('eng', "3", 131)
        setMultiboardCharWidthBase80('eng', "4", 111)
        setMultiboardCharWidthBase80('eng', "5", 131)
        setMultiboardCharWidthBase80('eng', "6", 120)
        setMultiboardCharWidthBase80('eng', "7", 131)
        setMultiboardCharWidthBase80('eng', "8", 111)
        setMultiboardCharWidthBase80('eng', "9", 120)
        setMultiboardCharWidthBase80('eng', "0", 111)
        setMultiboardCharWidthBase80('eng', ":", 360)
        setMultiboardCharWidthBase80('eng', ";", 360)
        setMultiboardCharWidthBase80('eng', ".", 360)
        setMultiboardCharWidthBase80('eng', "#", 103)
        setMultiboardCharWidthBase80('eng', ",", 360)
        setMultiboardCharWidthBase80('eng', " ", 288) --space
        setMultiboardCharWidthBase80('eng', "'", 480)
        setMultiboardCharWidthBase80('eng', "!", 360)
        setMultiboardCharWidthBase80('eng', "$", 131)
        setMultiboardCharWidthBase80('eng', "&", 120)
        setMultiboardCharWidthBase80('eng', "/", 180)
        setMultiboardCharWidthBase80('eng', "(", 240)
        setMultiboardCharWidthBase80('eng', ")", 240)
        setMultiboardCharWidthBase80('eng', "=", 111)
        setMultiboardCharWidthBase80('eng', "?", 180)
        setMultiboardCharWidthBase80('eng', "^", 144)
        setMultiboardCharWidthBase80('eng', "<", 131)
        setMultiboardCharWidthBase80('eng', ">", 131)
        setMultiboardCharWidthBase80('eng', "-", 180)
        setMultiboardCharWidthBase80('eng', "+", 111)
        setMultiboardCharWidthBase80('eng', "*", 180)
        setMultiboardCharWidthBase80('eng', "|", 480) --2 vertical bars in a row escape to one. So you could print 960 ones in a line, 480 would display. Maybe need to adapt to this before calculating string width.
        setMultiboardCharWidthBase80('eng', "~", 144)
        setMultiboardCharWidthBase80('eng', "{", 240)
        setMultiboardCharWidthBase80('eng', "}", 240)
        setMultiboardCharWidthBase80('eng', "[", 240)
        setMultiboardCharWidthBase80('eng', "]", 240)
        setMultiboardCharWidthBase80('eng', "_", 120)
        setMultiboardCharWidthBase80('eng', "\x25", 103) --percent
        setMultiboardCharWidthBase80('eng', "\x5C", 180) --backslash
        setMultiboardCharWidthBase80('eng', "\x22", 206) --double quotation mark
        setMultiboardCharWidthBase80('eng', "\x40", 96) --at sign
        setMultiboardCharWidthBase80('eng', "\x60", 206) --Gravis (Accent)
    end
end

if Debug and Debug.endFile then Debug.endFile() end
if Debug then Debug.beginFile 'TotalInitialization' end
--[[——————————————————————————————————————————————————————
    Total Initialization version 5.3.1
    Created by: Bribe
    Contributors: Eikonium, HerlySQR, Tasyen, Luashine, Forsakn
    Inspiration: Almia, ScorpioT1000, Troll-Brain
    Hosted at: https://github.com/BribeFromTheHive/Lua/blob/master/TotalInitialization.lua
    Debug library hosted at: https://www.hiveworkshop.com/threads/debug-utils-ingame-console-etc.330758/
————————————————————————————————————————————————————————————]]

---Calls the user's initialization function during the map's loading process. The first argument should either be the init function,
---or it should be the string to give the initializer a name (works similarly to a module name/identically to a vJass library name).
---
---To use requirements, call `Require.strict 'LibraryName'` or `Require.optional 'LibraryName'`. Alternatively, the OnInit callback
---function can take the `Require` table as a single parameter: `OnInit(function(import) import.strict 'ThisIsTheSameAsRequire' end)`.
---
-- - `OnInit.global` or just `OnInit` is called after InitGlobals and is the standard point to initialize.
-- - `OnInit.trig` is called after InitCustomTriggers, and is useful for removing hooks that should only apply to GUI events.
-- - `OnInit.map` is the last point in initialization before the loading screen is completed.
-- - `OnInit.final` occurs immediately after the loading screen has disappeared, and the game has started.
---@class OnInit
--
--Simple Initialization without declaring a library name:
---@overload async fun(initCallback: Initializer.Callback)
--
--Advanced initialization with a library name and an optional third argument to signal to Eikonium's DebugUtils that the file has ended.
---@overload async fun(libraryName: string, initCallback: Initializer.Callback, debugLineNum?: integer)
--
--A way to yield your library to allow other libraries in the same initialization sequence to load, then resume once they have loaded.
---@overload async fun(customInitializerName: string)
OnInit = {}

---@alias Initializer.Callback fun(require?: Requirement | {[string]: Requirement}):...?

---@alias Requirement async fun(reqName: string, source?: table): unknown

-- `Require` will yield the calling `OnInit` initialization function until the requirement (referenced as a string) exists. It will check the
-- global API (for example, does 'GlobalRemap' exist) and then check for any named OnInit resources which might use that same string as its name.
--
-- Due to the way Sumneko's syntax highlighter works, the return value will only be linted for defined @class objects (and doesn't work for regular
-- globals like `TimerStart`). I tried to request the functionality here: https://github.com/sumneko/lua-language-server/issues/1792 , however it
-- was closed. Presumably, there are other requests asking for it, but I wouldn't count on it.
--
-- To declare a requirement, use: `Require.strict 'SomeLibrary'` or (if you don't care about the missing linting functionality) `Require 'SomeLibrary'`
--
-- To optionally require something, use any other suffix (such as `.optionally` or `.nonstrict`): `Require.optional 'SomeLibrary'`
--
---@class Require: { [string]: Requirement }
---@overload async fun(reqName: string, source?: table): string
Require = {}
do
    local library = {} --You can change this to false if you don't use `Require` nor the `OnInit.library` API.

    --CONFIGURABLE LEGACY API FUNCTION:
    ---@param _ENV table
    ---@param OnInit any
    local function assignLegacyAPI(_ENV, OnInit)
        OnGlobalInit = OnInit; OnTrigInit = OnInit.trig; OnMapInit = OnInit.map; OnGameStart = OnInit.final              --Global Initialization Lite API
        --OnMainInit = OnInit.main; OnLibraryInit = OnInit.library; OnGameInit = OnInit.final                            --short-lived experimental API
        --onGlobalInit = OnInit; onTriggerInit = OnInit.trig; onInitialization = OnInit.map; onGameStart = OnInit.final  --original Global Initialization API
        --OnTriggerInit = OnInit.trig; OnInitialization = OnInit.map                                                     --Forsakn's Ordered Indices API
    end
    --END CONFIGURABLES

    local _G, rawget, insert =
    _G, rawget, table.insert

    local initFuncQueue = {}

    ---@param name string
    ---@param continue? function
    local function runInitializers(name, continue)
        --print('running:', name, tostring(initFuncQueue[name]))
        if initFuncQueue[name] then
            for _,func in ipairs(initFuncQueue[name]) do
                coroutine.wrap(func)(Require)
            end
            initFuncQueue[name] = nil
        end
        if library then
            library:resume()
        end
        if continue then
            continue()
        end
    end

    local function initEverything()
        ---@param hookName string
        ---@param continue? function
        local function hook(hookName, continue)
            local hookedFunc = rawget(_G, hookName)
            if hookedFunc then
                rawset(_G, hookName,
                        function()
                            hookedFunc()
                            runInitializers(hookName, continue)
                        end
                )
            else
                runInitializers(hookName, continue)
            end
        end

        hook(
                'InitGlobals',
                function()
                    hook(
                            'InitCustomTriggers',
                            function()
                                hook('RunInitializationTriggers')
                            end
                    )
                end
        )

        hook(
                'MarkGameStarted',
                function()
                    if library then
                        for _,func in ipairs(library.queuedInitializerList) do
                            func(nil, true) --run errors for missing requirements.
                        end
                        for _,func in pairs(library.yieldedModuleMatrix) do
                            func(true) --run errors for modules that aren't required.
                        end
                    end
                    OnInit = nil
                    Require = nil
                end
        )
    end

    ---@param initName       string
    ---@param libraryName    string | Initializer.Callback
    ---@param func?          Initializer.Callback
    ---@param debugLineNum?  integer
    ---@param incDebugLevel? boolean
    local function addUserFunc(initName, libraryName, func, debugLineNum, incDebugLevel)
        if not func then
            ---@cast libraryName Initializer.Callback
            func = libraryName
        else
            assert(type(libraryName) == 'string')
            if debugLineNum and Debug then
                Debug.beginFile(libraryName, incDebugLevel and 3 or 2)
                Debug.data.sourceMap[#Debug.data.sourceMap].lastLine = debugLineNum
            end
            if library then
                func = library:create(libraryName, func)
            end
        end
        assert(type(func) == 'function')

        --print('adding user func: ' , initName , libraryName, debugLineNum, incDebugLevel)

        initFuncQueue[initName] = initFuncQueue[initName] or {}
        insert(initFuncQueue[initName], func)

        if initName == 'root' or initName == 'module' then
            runInitializers(initName)
        end
    end

    ---@param name string
    local function createInit(name)
        ---@async
        ---@param libraryName string                --Assign your callback a unique name, allowing other OnInit callbacks can use it as a requirement.
        ---@param userInitFunc Initializer.Callback --Define a function to be called at the chosen point in the initialization process. It can optionally take the `Require` object as a parameter. Its optional return value(s) are passed to a requiring library via the `Require` object (defaults to `true`).
        ---@param debugLineNum? integer             --If the Debug library is present, you can call Debug.getLine() for this parameter (which should coincide with the last line of your script file). This will neatly tie-in with OnInit's built-in Debug library functionality to define a starting line and an ending line for your module.
        ---@overload async fun(userInitFunc: Initializer.Callback)
        return function(libraryName, userInitFunc, debugLineNum)
            addUserFunc(name, libraryName, userInitFunc, debugLineNum)
        end
    end
    OnInit.global = createInit 'InitGlobals'                -- Called after InitGlobals, and is the standard point to initialize.
    OnInit.trig   = createInit 'InitCustomTriggers'         -- Called after InitCustomTriggers, and is useful for removing hooks that should only apply to GUI events.
    OnInit.map    = createInit 'RunInitializationTriggers'  -- Called last in the script's loading screen sequence. Runs after the GUI "Map Initialization" events have run.
    OnInit.final  = createInit 'MarkGameStarted'            -- Called immediately after the loading screen has disappeared, and the game has started.

    do
        ---@param self table
        ---@param libraryNameOrInitFunc function | string
        ---@param userInitFunc function
        ---@param debugLineNum number
        local function __call(
                self,
                libraryNameOrInitFunc,
                userInitFunc,
                debugLineNum
        )
            if userInitFunc or type(libraryNameOrInitFunc) == 'function' then
                addUserFunc(
                        'InitGlobals', --Calling OnInit directly defaults to OnInit.global (AKA OnGlobalInit)
                        libraryNameOrInitFunc,
                        userInitFunc,
                        debugLineNum,
                        true
                )
            elseif library then
                library:declare(libraryNameOrInitFunc) --API handler for OnInit "Custom initializer"
            else
                error(
                        "Bad OnInit args: "..
                                tostring(libraryNameOrInitFunc) .. ", " ..
                                tostring(userInitFunc)
                )
            end
        end
        setmetatable(OnInit --[[@as table]], { __call = __call })
    end

    do --if you don't need the initializers for 'root', 'config' and 'main', you can delete this do...end block.
        local gmt = getmetatable(_G) or
                getmetatable(setmetatable(_G, {}))

        local rawIndex = gmt.__newindex or rawset

        local hookMainAndConfig
        ---@param _G table
        ---@param key string
        ---@param fnOrDiscard unknown
        function hookMainAndConfig(_G, key, fnOrDiscard)
            if key == 'main' or key == 'config' then
                ---@cast fnOrDiscard function
                if key == 'main' then
                    runInitializers 'root'
                end
                rawIndex(_G, key, function()
                    if key == 'config' then
                        fnOrDiscard()
                    elseif gmt.__newindex == hookMainAndConfig then
                        gmt.__newindex = rawIndex --restore the original __newindex if no further hooks on __newindex exist.
                    end
                    runInitializers(key)
                    if key == 'main' then
                        fnOrDiscard()
                    end
                end)
            else
                rawIndex(_G, key, fnOrDiscard)
            end
        end
        gmt.__newindex = hookMainAndConfig
        OnInit.root    = createInit 'root'   -- Runs immediately during the Lua root, but is yieldable (allowing requirements) and pcalled.
        OnInit.config  = createInit 'config' -- Runs when `config` is called. Credit to @Luashine: https://www.hiveworkshop.com/threads/inject-main-config-from-we-trigger-code-like-jasshelper.338201/
        OnInit.main    = createInit 'main'   -- Runs when `main` is called. Idea from @Tasyen: https://www.hiveworkshop.com/threads/global-initialization.317099/post-3374063
    end
    if library then
        library.queuedInitializerList = {}
        library.customDeclarationList = {}
        library.yieldedModuleMatrix   = {}
        library.moduleValueMatrix     = {}

        function library:pack(name, ...)
            self.moduleValueMatrix[name] = table.pack(...)
        end

        function library:resume()
            if self.queuedInitializerList[1] then
                local continue, tempQueue, forceOptional

                ::initLibraries::
                repeat
                    continue=false
                    self.queuedInitializerList, tempQueue =
                    {}, self.queuedInitializerList

                    for _,func in ipairs(tempQueue) do
                        if func(forceOptional) then
                            continue=true --Something was initialized; therefore further systems might be able to initialize.
                        else
                            insert(self.queuedInitializerList, func) --If the queued initializer returns false, that means its requirement wasn't met, so we re-queue it.
                        end
                    end
                until not continue or not self.queuedInitializerList[1]

                if self.customDeclarationList[1] then
                    self.customDeclarationList, tempQueue =
                    {}, self.customDeclarationList
                    for _,func in ipairs(tempQueue) do
                        func() --unfreeze any custom initializers.
                    end
                elseif not forceOptional then
                    forceOptional = true
                else
                    return
                end
                goto initLibraries
            end
        end
        local function declareName(name, initialValue)
            assert(type(name) == 'string')
            assert(library.moduleValueMatrix[name] == nil)
            library.moduleValueMatrix[name] =
            initialValue and { true, n = 1 }
        end
        function library:create(name, userFunc)
            assert(type(userFunc) == 'function')
            declareName(name, false)                --declare itself as a non-loaded library.
            return function()
                self:pack(name, userFunc(Require))  --pack return values to allow multiple values to be communicated.
                if self.moduleValueMatrix[name].n == 0 then
                    self:pack(name, true)           --No values were returned; therefore simply package the value as `true`
                end
            end
        end

        ---@async
        function library:declare(name)
            declareName(name, true)                 --declare itself as a loaded library.

            local co = coroutine.running()

            insert(
                    self.customDeclarationList,
                    function()
                        coroutine.resume(co)
                    end
            )
            coroutine.yield() --yields the calling function until after all currently-queued initializers have run.
        end

        local processRequirement

        ---@async
        function processRequirement(
                optional,
                requirement,
                explicitSource
        )
            if type(optional) == 'string' then
                optional, requirement, explicitSource =
                true, optional, requirement --optional requirement (processed by the __index method)
            else
                optional = false --strict requirement (processed by the __call method)
            end
            local source = explicitSource or _G

            assert(type(source)=='table')
            assert(type(requirement)=='string')

            ::reindex::
            local subSource, subReq =
            requirement:match("([\x25w_]+)\x25.(.+)") --Check if user is requiring using "table.property" syntax
            if subSource and subReq then
                source,
                requirement =
                processRequirement(subSource, source), --If the container is nil, yield until it is not.
                subReq

                if type(source)=='table' then
                    explicitSource = source
                    goto reindex --check for further nested properties ("table.property.subProperty.anyOthers").
                else
                    return --The source table for the requirement wasn't found, so disregard the rest (this only happens with optional requirements).
                end
            end
            local function loadRequirement(unpack)
                local package = rawget(source, requirement) --check if the requirement exists in the host table.
                if not package and not explicitSource then
                    if library.yieldedModuleMatrix[requirement] then
                        library.yieldedModuleMatrix[requirement]() --load module if it exists
                    end
                    package = library.moduleValueMatrix[requirement] --retrieve the return value from the module.
                    if unpack and type(package)=='table' then
                        return table.unpack(package, 1, package.n) --using unpack allows any number of values to be returned by the required library.
                    end
                end
                return package
            end

            local co, loaded

            local function checkReqs(forceOptional, printErrors)
                if not loaded then
                    loaded = loadRequirement()
                    loaded = loaded or optional and
                            (loaded==nil or forceOptional)
                    if loaded then
                        if co then coroutine.resume(co) end --resume only if it was yielded in the first place.
                        return loaded
                    elseif printErrors then
                        coroutine.resume(co, true)
                    end
                end
            end

            if not checkReqs() then --only yield if the requirement doesn't already exist.
                co = coroutine.running()
                insert(library.queuedInitializerList, checkReqs)
                if coroutine.yield() then
                    error("Missing Requirement: "..requirement) --handle the error within the user's function to get an accurate stack trace via the `try` function.
                end
            end

            return loadRequirement(true)
        end

        ---@type Requirement
        function Require.strict(name, explicitSource)
            return processRequirement(nil, name, explicitSource)
        end

        setmetatable(Require --[[@as table]], {
            __call = processRequirement,
            __index = function()
                return processRequirement
            end
        })

        local module  = createInit 'module'

        --- `OnInit.module` will only call the OnInit function if the module is required by another resource, rather than being called at a pre-
        --- specified point in the loading process. It works similarly to Go, in that including modules in your map that are not actually being
        --- required will throw an error message.
        ---@param name          string
        ---@param func          fun(require?: Initializer.Callback):any
        ---@param debugLineNum? integer
        OnInit.module = function(name, func, debugLineNum)
            if func then
                local userFunc = func
                func = function(require)
                    local co = coroutine.running()

                    library.yieldedModuleMatrix[name] =
                    function(failure)
                        library.yieldedModuleMatrix[name] = nil
                        coroutine.resume(co, failure)
                    end

                    if coroutine.yield() then
                        error("Module declared but not required: "..name)
                    end

                    return userFunc(require)
                end
            end
            module(name, func, debugLineNum)
        end
    end

    if assignLegacyAPI then --This block handles legacy code.
        ---Allows packaging multiple requirements into one table and queues the initialization for later.
        ---@deprecated
        ---@param initList string | table
        ---@param userFunc function
        function OnInit.library(initList, userFunc)
            local typeOf = type(initList)

            assert(typeOf=='table' or typeOf=='string')
            assert(type(userFunc) == 'function')

            local function caller(use)
                if typeOf=='string' then
                    use(initList)
                else
                    for _,initName in ipairs(initList) do
                        use(initName)
                    end
                    if initList.optional then
                        for _,initName in ipairs(initList.optional) do
                            use.lazily(initName)
                        end
                    end
                end
            end
            if initList.name then
                OnInit(initList.name, caller)
            else
                OnInit(caller)
            end
        end

        local legacyTable = {}

        assignLegacyAPI(legacyTable, OnInit)

        for key,func in pairs(legacyTable) do
            rawset(_G, key, func)
        end

        OnInit.final(function()
            for key in pairs(legacyTable) do
                rawset(_G, key, nil)
            end
        end)
    end

    initEverything()
end
if Debug then Debug.endFile() end
---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by WGPavell.
--- DateTime: 24.03.2025 19:44
---

--- @class SimpleBaseFrame
SimpleBaseFrame = {}
function SimpleBaseFrame:new()
    local obj = {handle = nil}

    ---setSize
    ---@param width number
    ---@param height number
    function obj:setSize(width, height)
        BlzFrameSetSize(self.handle, width, height)
        return self
    end

    ---setAbsPoint
    ---@param point framepointtype
    ---@param x number
    ---@param y number
    function obj:setAbsPoint(point, x, y)
        BlzFrameSetAbsPoint(self.handle, point, x, y)
        return self
    end

    ---setRelativePoint
    ---@param selfPoint framepointtype
    ---@param relativeFrame framehandle
    ---@param relativePoint framepointtype
    ---@param x number
    ---@param y number
    function obj:setRelativePoint(selfPoint, relativeFrame, relativePoint, x, y)
        BlzFrameSetPoint(self.handle, selfPoint, relativeFrame, relativePoint, x, y)
        return self
    end

    ---setScale
    ---@param scale number
    function obj:setScale(scale)
        BlzFrameSetScale(self.handle, scale)
        return self
    end

    ---setVisible
    ---@param visibility boolean
    function obj:setVisible(visibility)
        BlzFrameSetVisible(self.handle, visibility)
        return self
    end

    ---setAlpha
    ---@param alpha integer
    function obj:setAlpha(alpha)
        BlzFrameSetAlpha(self.handle, alpha)
        return self
    end

    ---animateFadeIn
    ---@param duration number
    ---@param callback function
    function obj:animateFadeIn(duration, callback)
        local timer = CreateTimer()
        local ticks = 0
        local alphaPerTick = 255 / duration / 60
        self:setAlpha(0):setVisible(true)
        TimerStart(timer, 1 / 60, true, function()
            local newAlpha = math.floor(alphaPerTick * ticks + 0.5)
            ticks = ticks + 1
            self:setAlpha(newAlpha)
            if newAlpha >= 255 then
                PauseTimer(timer)
                DestroyTimer(timer)
                if type(callback) == "function" then
                    callback()
                end
            end
        end)
        return self
    end

    ---animateFadeOut
    ---@param duration number
    ---@param callback function
    function obj:animateFadeOut(duration, callback)
        local timer = CreateTimer()
        local ticks = 0
        local alphaPerTick = 255 / duration / 60
        self:setVisible(true):setAlpha(255)
        TimerStart(timer, 1 / 60, true, function()
            local newAlpha = math.floor(255 - alphaPerTick * ticks + 0.5)
            ticks = ticks + 1
            self:setAlpha(newAlpha)
            if newAlpha <= 0 then
                PauseTimer(timer)
                DestroyTimer(timer)
                self:setVisible(false)
                if type(callback) == "function" then
                    callback()
                end
            end
        end)
        return self
    end

    ---getWidth
    function obj:getWidth()
        return BlzFrameGetWidth(self.handle)
    end

    ---getHeight
    function obj:getHeight()
        return BlzFrameGetHeight(self.handle)
    end

    ---animateSize
    ---@param duration number
    ---@param toWidth number
    ---@param toHeight number
    ---@param fromWidth number
    ---@param fromHeight number
    ---@param callback function
    function obj:animateSize(duration, toWidth, toHeight, fromWidth, fromHeight, callback)
        local animateWidth = toWidth ~= nil
        local animateHeight = toHeight ~= nil
        fromWidth = fromWidth == nil and self:getWidth() or fromWidth
        fromHeight = fromHeight == nil and self:getHeight() or fromHeight
        local ticks = 0
        local finishTicks = duration * 60
        local timer = CreateTimer()
        local widthPerTick = animateWidth and (toWidth - fromWidth) / duration / 60 or 0
        local heightPerTick = animateHeight and (toHeight - fromHeight) / duration / 60 or 0
        TimerStart(timer, 1 / 60, true, function()
            ticks = ticks + 1
            self:setSize(fromWidth + (widthPerTick * ticks), fromHeight + (heightPerTick * ticks))
            if ticks >= finishTicks then
                PauseTimer(timer)
                DestroyTimer(timer)
                if type(callback) == "function" then
                    callback()
                end
            end
        end)
        return self
    end

    ---resetPoints
    function obj:resetPoints()
        BlzFrameClearAllPoints(self.handle)
        return self
    end

    function obj:setAllPoints(relative)
        BlzFrameSetAllPoints(self.handle, relative)
        return self
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end

--- @class SimpleTypeFrame
SimpleTypeFrame = {}
setmetatable(SimpleTypeFrame, {__index = SimpleBaseFrame})
---new
---@param name string
---@param frameType string
---@param parent framehandle
---@param inherits string
---@param context integer
function SimpleTypeFrame:new(name, frameType, parent, inherits, context)
    local frame = SimpleBaseFrame:new()
    frame.handle = BlzCreateFrameByType(frameType, name, parent, inherits or "", context or 0)
    return frame
end

--- @class SimpleTemplateFrame
SimpleTemplateFrame = {}
setmetatable(SimpleTemplateFrame, {__index = SimpleBaseFrame})
---new
---@param template string
---@param parent framehandle
---@param priority integer
---@param context integer
function SimpleTemplateFrame:new(template, parent, priority, context)
    local frame = SimpleBaseFrame:new()
    frame.handle = BlzCreateFrame(template, parent, priority or 0, context or 0)
    return frame
end

--- @class SimpleSimpleFrame
SimpleSimpleFrame = {}
setmetatable(SimpleSimpleFrame, {__index = SimpleBaseFrame})
---new
---@param template string
---@param parent framehandle
---@param context integer
function SimpleSimpleFrame:new(template, parent, context)
    local frame = SimpleBaseFrame:new()
    frame.handle = BlzCreateSimpleFrame(template, parent, context or 0)
    return frame
end

--- @class SimpleEmptyFrame
SimpleEmptyFrame = {}
setmetatable(SimpleEmptyFrame, {__index = SimpleTypeFrame})
---new
---@param name string
---@param parent framehandle
---@param context integer
function SimpleEmptyFrame:new(name, parent, context)
    return SimpleTypeFrame:new(name, "FRAME", parent, "", context)
end

--- @class SimpleBackdropTextureFrame
SimpleBackdropTextureFrame = {}
setmetatable(SimpleBackdropTextureFrame, { __index = SimpleTypeFrame})
---new
---@param name string
---@param parent framehandle
---@param context integer
function SimpleBackdropTextureFrame:new(name, texturePath, parent, context)
    local frame = SimpleTypeFrame:new(name, "BACKDROP", parent, "", context)

    function frame:setTexture(texturePath)
        BlzFrameSetTexture(self.handle, texturePath, 0, true)
    end

    frame:setTexture(texturePath)

    return frame
end

--- @class SimpleTextFrame
SimpleTextFrame = {}
setmetatable(SimpleTextFrame, {__index = SimpleTypeFrame})
---new
---@param name string
---@param text string
---@param scale number
---@param parent framehandle
---@param context integer
function SimpleTextFrame:new(name, text, scale, parent, context)
    local frame = SimpleTypeFrame:new(name, "TEXT", parent, "", context)

    ---setText
    ---@param text string
    function frame:setText(text)
        BlzFrameSetText(self.handle, text)
        return self
    end

    ---setAlignment
    ---@param verticalAlignment textaligntype
    ---@param horizontalAlignment textaligntype
    function frame:setAlignment(verticalAlignment, horizontalAlignment)
        BlzFrameSetTextAlignment(self.handle, verticalAlignment, horizontalAlignment)
        return self
    end

    function frame:setColor(r, g, b, a)
        BlzFrameSetTextColor(self.handle, BlzConvertColor(a or 255, r, g, b))
        return self
    end

    frame:setText(text)
    frame:setScale(scale)

    return frame
end

--- @class TextureFrame
TextureFrame = {}
---new
---@param namePrefix string
---@param texturePath string
---@param parent framehandle
---@param context integer
function TextureFrame:new(namePrefix, texturePath, parent, context)
    local coverFrame = SimpleEmptyFrame:new(namePrefix .. "_cover", parent, context)
    local textureFrame = SimpleBackdropTextureFrame:new(namePrefix .. "_icon", texturePath, coverFrame.handle, context)
    textureFrame:setAllPoints(coverFrame.handle)

    local obj = {
        cover = coverFrame,
        texture = textureFrame
    }

    function obj:setTexture(texturePath)
        self.texture:setTexture(texturePath)
        return self
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end

UPGRADE_DATA_FRAME_TEXT_ALIGNMENT_RIGHT = 1
UPGRADE_DATA_FRAME_TEXT_ALIGNMENT_LEFT = 2

--- @class UpgradeDataFrame
UpgradeDataFrame = {}
---new
---@param namePrefix string
---@param iconPath string
---@param text string
---@param textScale number
---@param textAlignment number
---@param parent framehandle
---@param context integer
function UpgradeDataFrame:new(namePrefix, iconPath, text, textScale, textAlignment, parent, context)
    local coverFrame = SimpleEmptyFrame:new(namePrefix .. "_cover", parent, context)
    local iconFrame = TextureFrame:new(namePrefix .. "_icon", iconPath, coverFrame.handle, context)
    local textFrame = SimpleTextFrame:new(namePrefix .. "_text", text, textScale, coverFrame.handle, context)
    if textAlignment == UPGRADE_DATA_FRAME_TEXT_ALIGNMENT_RIGHT then
        iconFrame.cover:setRelativePoint(FRAMEPOINT_LEFT, coverFrame.handle, FRAMEPOINT_LEFT, 0, 0)
        textFrame:setRelativePoint(FRAMEPOINT_LEFT, iconFrame.cover.handle, FRAMEPOINT_RIGHT, 0.0008 * textScale, 0)
        textFrame:setRelativePoint(FRAMEPOINT_RIGHT, coverFrame.handle, FRAMEPOINT_RIGHT, 0, 0)
    else
        iconFrame.cover:setRelativePoint(FRAMEPOINT_RIGHT, coverFrame.handle, FRAMEPOINT_RIGHT, 0, 0)
        textFrame:setRelativePoint(FRAMEPOINT_RIGHT, iconFrame.cover.handle, FRAMEPOINT_LEFT, -0.0008 * textScale, 0)
        textFrame:setRelativePoint(FRAMEPOINT_LEFT, coverFrame.handle, FRAMEPOINT_LEFT, 0, 0)
    end
    textFrame:setAlignment(TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)

    local obj = {
        cover = coverFrame,
        icon = iconFrame,
        text = textFrame
    }

    function obj:setIconPath(iconPath)
        self.icon:setTexture(iconPath)
        return self
    end

    function obj:setText(text)
        self.text:setText(text)
        return self
    end

    function obj:setTextScale(scale)
        self.text:setScale(scale)
        return self
    end

    function obj:setVisible(visibility)
        self.cover:setVisible(visibility)
        return self
    end

    function obj:setSize(width, height)
        self.cover:setSize(width, height)
        self.icon.cover:setSize(math.min(width, height), math.min(width, height))
        return self
    end

    setmetatable(obj, self)
    self.__index = self
    return obj
end

--- @class TemplateBackdropFrame
TemplateBackdropFrame = {}
---new
---@param namePrefix string
---@param template string
---@param parent framehandle
---@param priority integer
---@param context integer
function TemplateBackdropFrame:new(namePrefix, template, parent, priority, context)
    local coverFrame = SimpleEmptyFrame:new(namePrefix .. "_cover", parent, context)
    local backdropFrame = SimpleTemplateFrame:new(template, coverFrame.handle, priority, context)
    backdropFrame:setAllPoints(coverFrame.handle)

    local obj = {
        cover = coverFrame,
        backdrop = backdropFrame
    }

    setmetatable(obj, self)
    self.__index = self
    return obj
end
---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Pavell.
--- DateTime: 26.03.2025 19:01
---

local function has_value (tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end
---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by WGPavell.
--- DateTime: 22.03.2025 16:07
---

RaceUnits = {
    race = "",
    codes = {}
}
RaceUnits.__index = RaceUnits

function RaceUnits:new(race, codes)
    local data = {
        race = race,
        codes = codes
    }
    setmetatable(data, self)
    self.__index = self
    return data
end

local TargetData = {
    ground = false,
    air = false
}
TargetData.__index = TargetData

function TargetData:new(ground, air)
    local data = {
        ground = ground,
        air = air
    }
    setmetatable(data, self)
    self.__index = self
    return data
end

UnitData = {
    code = "",
    name = "",
    is_hero = false,
    food_cost = 0,
    unit_target = TargetData:new(false, false),
    attack_target = TargetData:new(false, false)
}
UnitData.__index = UnitData

function UnitData:new(code, name, is_hero, food_cost, unit_target, attack_target)
    local data = {
        code = code,
        name = name,
        is_hero = is_hero,
        food_cost = food_cost,
        unit_target = unit_target,
        attack_target = attack_target
    }
    setmetatable(data, self)
    self.__index = self
    return data
end
---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by WGPavell.
--- DateTime: 27.03.2025 19:02
---

---DelayCallback
---@param timeout number
---@param callback function
function DelayCallback(timeout, callback)
    TimerStart(CreateTimer(), timeout, false, callback)
end
---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by WGPavell.
--- DateTime: 22.03.2025 13:10
---

TARGET_FLAG_NONE_INT = 1
TARGET_FLAG_GROUND_INT = 2
TARGET_FLAG_AIR_INT = 4
TARGET_FLAG_STRUCTURE_INT = 8
TARGET_FLAG_WARD_INT = 16
TARGET_FLAG_ITEM_INT = 32
TARGET_FLAG_TREE_INT = 64
TARGET_FLAG_WALL_INT = 128
TARGET_FLAG_DEBRIS_INT = 256
TARGET_FLAG_DECORATION_INT = 512
TARGET_FLAG_BRIDGE_INT = 1024

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end

---debugPrint
---@param message string
function debugPrint(message)
    DisplayTextToPlayer(Player(0), 0, 0, message)
end

---debugPrintAny
---@param object any
function debugPrintAny(object)
    debugPrint(tostring(object))
end

-- Why I don't use GetLocalizedString here? Because of some reason it doesn't work before main function
unitGroups = {
    {
        id = "human",
        race_key = "KEY_HUMAN",
        unit_codes = {'hpea', 'hfoo', 'hrif', 'hkni', 'hsor', 'hmpr', 'hspt', 'hgyr', 'hmtm', 'hmtt', 'hgry', 'hdhw', 'Hpal', 'Hamg', 'Hmkg', 'Hblm'}
    },
    {
        id = "orc",
        race_key = "KEY_ORC",
        unit_codes = {'opeo', 'ogru', 'ohun', 'ocat', 'oshm', 'odoc', 'ospw', 'orai', 'okod', 'owyv', 'otbr', 'otau', 'Obla', 'Ofar', 'Otch', 'Oshd'}
    },
    {
        id = "undead",
        race_key = "KEY_UNDEAD",
        unit_codes = {'uaco', 'ugho', 'ucry', 'ugar', 'unec', 'uban', 'umtw', 'uabo', 'uobs', 'ufro', 'Udea', 'Ulic', 'Udre', 'Ucrl'}
    },
    {
        id = "nightelf",
        race_key = "KEY_NIGHTELF",
        unit_codes = {'earc', 'esen', 'ebal', 'edry', 'edoc', 'emtg', 'ehip', 'ehpr', 'edot', 'efdr', 'echm', 'Ekee', 'Emoo', 'Edem', 'Ewar'}
    },
}

upgrades = {
    {
        code = 'Rhla',
        units = {'hdhw', 'hgry', 'hmtm', 'hrif'}
    },
    {
        code = 'Rhme',
        units = {'hdhw', 'hfoo', 'hgry', 'hkni', 'hspt'}
    },
    {
        code = 'Rguv',
        units = {'hdhw', 'hfoo', 'hgry', 'hgyr', 'hkni', 'hmpr', 'hmtm', 'hmtt', 'hpea', 'hrif', 'hsor', 'hspt', 'ocat', 'odoc', 'ogru', 'ohun', 'okod', 'opeo', 'orai', 'oshm', 'ospw', 'otau', 'otbr', 'owyv', 'uabo', 'uaco', 'uban', 'ucry', 'ufro', 'ugar', 'ugho', 'umtw', 'unec', 'uobs'}
    },
    {
        code = 'Rhan',
        units = {'hdhw', 'hgry', 'hkni'}
    },
    {
        code = 'Rhcd',
        units = {'hdhw'}
    },
    {
        code = 'Rhar',
        units = {'hfoo', 'hgyr', 'hkni', 'hmtt', 'hspt'}
    },
    {
        code = 'Rhde',
        units = {'hfoo'}
    },
    {
        code = 'Rhpm',
        units = {'hfoo', 'hkni', 'hmpr', 'hrif', 'hsor', 'hspt'}
    },
    {
        code = 'Rhhb',
        units = {'hgry'}
    },
    {
        code = 'Rhra',
        units = {'hgyr', 'hmtm', 'hmtt', 'hrif'}
    },
    {
        code = 'Rhgb',
        units = {'hgyr'}
    },
    {
        code = 'Rhfc',
        units = {'hgyr'}
    },
    {
        code = 'Rhsb',
        units = {'hkni'}
    },
    {
        code = 'Rhpt',
        units = {'hmpr'}
    },
    {
        code = 'Rhfl',
        units = {'hmtm'}
    },
    {
        code = 'Rhfs',
        units = {'hmtm'}
    },
    {
        code = 'Rhrt',
        units = {'hmtt'}
    },
    {
        code = 'Rhlh',
        units = {'hpea'}
    },
    {
        code = 'Rhri',
        units = {'hrif'}
    },
    {
        code = 'Rhst',
        units = {'hsor'}
    },
    {
        code = 'Rhss',
        units = {'hspt'}
    },
    {
        code = 'Roar',
        units = {'ocat', 'ogru', 'ohun', 'orai', 'otau', 'otbr', 'owyv'}
    },
    {
        code = 'Rora',
        units = {'ocat', 'ohun', 'otbr', 'owyv'}
    },
    {
        code = 'Robf',
        units = {'ocat'}
    },
    {
        code = 'Rolf',
        units = {'ocat'}
    },
    {
        code = 'Rowd',
        units = {'odoc'}
    },
    {
        code = 'Rotr',
        units = {'odoc', 'ohun', 'otbr'}
    },
    {
        code = 'Ropm',
        units = {'odoc', 'ogru', 'ohun', 'orai', 'oshm', 'ospw', 'otau'}
    },
    {
        code = 'Rome',
        units = {'ogru', 'orai', 'otau'}
    },
    {
        code = 'Robs',
        units = {'ogru'}
    },
    {
        code = 'Ropg',
        units = {'ogru', 'opeo', 'orai'}
    },
    {
        code = 'Robk',
        units = {'ohun'}
    },
    {
        code = 'Rwdm',
        units = {'okod'}
    },
    {
        code = 'Roen',
        units = {'orai'}
    },
    {
        code = 'Rost',
        units = {'oshm'}
    },
    {
        code = 'Rowt',
        units = {'ospw'}
    },
    {
        code = 'Rows',
        units = {'otau'}
    },
    {
        code = 'Rovs',
        units = {'owyv'}
    },
    {
        code = 'Reuv',
        units = {'Edem', 'Ekee', 'Emoo', 'Ewar', 'earc', 'ebal', 'echm', 'edoc', 'edot', 'edry', 'efdr', 'ehip', 'ehpr', 'emtg', 'esen'}
    },
    {
        code = 'Resm',
        units = {'earc', 'ebal', 'ehpr', 'esen'}
    },
    {
        code = 'Rema',
        units = {'earc', 'ehpr', 'esen'}
    },
    {
        code = 'Reib',
        units = {'earc', 'ehpr'}
    },
    {
        code = 'Remk',
        units = {'earc', 'ehpr'}
    },
    {
        code = 'Repm',
        units = {'earc', 'edoc', 'edot', 'edry', 'emtg', 'esen'}
    },
    {
        code = 'Repb',
        units = {'ebal'}
    },
    {
        code = 'Resw',
        units = {'echm', 'edry', 'efdr', 'ehip', 'emtg'}
    },
    {
        code = 'Rerh',
        units = {'echm', 'edry', 'efdr', 'ehip', 'emtg'}
    },
    {
        code = 'Recb',
        units = {'echm'}
    },
    {
        code = 'Redc',
        units = {'edoc'}
    },
    {
        code = 'Reeb',
        units = {'edoc'}
    },
    {
        code = 'Redt',
        units = {'edot'}
    },
    {
        code = 'Reec',
        units = {'edot'}
    },
    {
        code = 'Resi',
        units = {'edry'}
    },
    {
        code = 'Reht',
        units = {'ehip', 'ehpr'}
    },
    {
        code = 'Rers',
        units = {'emtg'}
    },
    {
        code = 'Rehs',
        units = {'emtg'}
    },
    {
        code = 'Resc',
        units = {'esen'}
    },
    {
        code = 'Remg',
        units = {'esen'}
    },
    {
        code = 'Ruar',
        units = {'uabo', 'ugho'}
    },
    {
        code = 'Rume',
        units = {'uabo', 'ugho', 'umtw'}
    },
    {
        code = 'Rupc',
        units = {'uabo', 'umtw'}
    },
    {
        code = 'Rupm',
        units = {'uabo', 'uban', 'ucry', 'ugho', 'unec'}
    },
    {
        code = 'Ruac',
        units = {'uabo', 'ugho'}
    },
    {
        code = 'Ruba',
        units = {'uban'}
    },
    {
        code = 'Rura',
        units = {'ucry', 'ufro', 'ugar'}
    },
    {
        code = 'Rucr',
        units = {'ucry', 'ufro', 'ugar'}
    },
    {
        code = 'Ruwb',
        units = {'ucry'}
    },
    {
        code = 'Rubu',
        units = {'ucry'}
    },
    {
        code = 'Rufb',
        units = {'ufro'}
    },
    {
        code = 'Rusf',
        units = {'ugar'}
    },
    {
        code = 'Rugf',
        units = {'ugho'}
    },
    {
        code = 'Rune',
        units = {'unec'}
    },
    {
        code = 'Rusm',
        units = {'unec'}
    },
    {
        code = 'Rusp',
        units = {'uobs'}
    }
}

heroAbilities = {
    Hamg = {'AHbz', 'AHab', 'AHwe', 'AHmt'},
    Hblm = {'AHfs', 'AHbn', 'AHdr', 'AHpx'},
    Hmkg = {'AHtc', 'AHtb', 'AHbh', 'AHav'},
    Hpal = {'AHhb', 'AHds', 'AHre', 'AHad'},
    Obla = {'AOwk', 'AOcr', 'AOmi', 'AOww'},
    Ofar = {'AOfs', 'AOsf', 'AOcl', 'AOeq'},
    Oshd = {'AOhw', 'AOhx', 'AOsw', 'AOvd'},
    Otch = {'AOsh', 'AOae', 'AOre', 'AOws'},
    Edem = {'AEmb', 'AEim', 'AEev', 'AEme'},
    Ekee = {'AEer', 'AEfn', 'AEah', 'AEtq'},
    Emoo = {'AHfa', 'AEst', 'AEar', 'AEsf'},
    Ewar = {'AEbl', 'AEfk', 'AEsh', 'AEsv'},
    Ucrl = {'AUim', 'AUts', 'AUcb', 'AUls'},
    Udea = {'AUdc', 'AUdp', 'AUau', 'AUan'},
    Udre = {'AUav', 'AUsl', 'AUcs', 'AUin'},
    Ulic = {'AUfn', 'AUfu', 'AUdr', 'AUdd'}
}
abilitiesIcons = {}

SPELL_IMMUNE_ABILITIES = {'Amim', 'ACm2', 'ACm3', 'ACmi'}
ANTI_AIR_ABILITIES = {'Aens', 'Aweb', 'ACen', 'ACwb'}

unitsUpgradesDependencies = {}
unitList = {}

OnInit.map(function()
    for _, upgrade in ipairs(upgrades) do
        upgrade.name = GetAbilityName(FourCC(upgrade.code))
        upgrade.icon = BlzGetAbilityIcon(FourCC(upgrade.code))
        for _, unit in ipairs(upgrade.units) do
            if unitsUpgradesDependencies[unit] == nil then
                unitsUpgradesDependencies[unit] = {}
            end
            table.insert(unitsUpgradesDependencies[unit], upgrade)
        end
    end

    for _, abilityList in pairs(heroAbilities) do
        for _, ability in ipairs(abilityList) do
            if abilitiesIcons[ability] == nil then
                abilitiesIcons[ability] = BlzGetAbilityIcon(FourCC(ability))
            end
        end
    end

    local subjectPlayer = Player(PLAYER_NEUTRAL_PASSIVE)
    for _, group in ipairs(unitGroups) do
        local unitsData = {}
        for _, code in ipairs(group.unit_codes) do
            local subject = CreateUnit(subjectPlayer, FourCC(code), 0, 0, 0)
            if unitsUpgradesDependencies[code] ~= nil then
                for _, upgrade in ipairs(unitsUpgradesDependencies[code]) do
                    SetPlayerTechResearched(subjectPlayer, FourCC(upgrade.code), GetPlayerTechMaxAllowed(subjectPlayer, FourCC(upgrade.code)))
                end
            end
            local targeted_as = BlzGetUnitIntegerField(subject, UNIT_IF_TARGETED_AS)
            local attack1_enabled = BlzGetUnitWeaponBooleanField(subject, UNIT_WEAPON_BF_ATTACKS_ENABLED, 0)
            local attack1_targets = BlzGetUnitWeaponIntegerField(subject, UNIT_WEAPON_IF_ATTACK_TARGETS_ALLOWED, 0)
            local attack1_magic = ConvertAttackType(BlzGetUnitWeaponIntegerField(subject, UNIT_WEAPON_IF_ATTACK_ATTACK_TYPE, 0)) == ATTACK_TYPE_MAGIC
            local attack2_enabled = BlzGetUnitWeaponBooleanField(subject, UNIT_WEAPON_BF_ATTACKS_ENABLED, 1)
            local attack2_targets = BlzGetUnitWeaponIntegerField(subject, UNIT_WEAPON_IF_ATTACK_TARGETS_ALLOWED, 1)
            local attack2_magic = ConvertAttackType(BlzGetUnitWeaponIntegerField(subject, UNIT_WEAPON_IF_ATTACK_ATTACK_TYPE, 1)) == ATTACK_TYPE_MAGIC
            local have_immune = false
            for _, spellId in ipairs(SPELL_IMMUNE_ABILITIES) do
                if GetUnitAbilityLevel(subject, FourCC(spellId)) > 0 then
                    have_immune = true
                    break
                end
            end
            local have_anti_air = false
            for _, spellId in ipairs(ANTI_AIR_ABILITIES) do
                if GetUnitAbilityLevel(subject, FourCC(spellId)) > 0 then
                    have_anti_air = true
                    break
                end
            end
            table.insert(unitsData, {
                code = code,
                name = BlzGetUnitStringField(subject, UNIT_SF_NAME),
                is_hero = IsUnitType(subject, UNIT_TYPE_HERO),
                food_cost = GetUnitFoodUsed(subject),
                unit_target = {
                    ground = targeted_as & TARGET_FLAG_GROUND_INT ~= 0,
                    air = targeted_as & TARGET_FLAG_AIR_INT ~= 0,
                    immune = have_immune
                },
                attack_target = {
                    ground = (attack1_enabled and attack1_targets & TARGET_FLAG_GROUND_INT ~= 0) or (attack2_enabled and attack2_targets & TARGET_FLAG_GROUND_INT ~= 0),
                    air = (attack1_enabled and attack1_targets & TARGET_FLAG_AIR_INT ~= 0) or (attack2_enabled and attack2_targets & TARGET_FLAG_AIR_INT ~= 0) or have_anti_air,
                    magic = (attack1_enabled or attack2_enabled) and ((not attack1_enabled or (attack1_enabled and attack1_magic)) and (not attack2_enabled or (attack2_enabled and attack2_magic))),
                },
                icon = BlzGetAbilityIcon(FourCC(code)),
                battles = 0,
                victories = 0,
                total_died = 0,
                total_killed = 0,
                history = {}
            })
            RemoveUnit(subject)
        end
        table.insert(unitList, {
            id = group.id,
            race = GetLocalizedString(group.race_key),
            units = unitsData
        })
    end
    --TimerStart(CreateTimer(), 0.1, false, function()
    --    debugPrint(dump(unitList))
    --end)
end)
---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by WGPavell.
--- DateTime: 24.03.2025 18:58
---

FRAMES_TO_HIDE = {'ConsoleBottomBarOverlay', 'CommandBarFrame'}
for i = 0, 11 do
    table.insert(FRAMES_TO_HIDE, "CommandButton_" .. i)
end

FULLSCREEN_CANVAS_SIZE_REFRESH_PERIOD = 0.02
--- @type SimpleEmptyFrame
fullscreenWrapperFrame = nil
--- @type SimpleEmptyFrame
fullscreenCanvasFrame = nil
fullscreenCanvasTimer = CreateTimer()

function GetScreenFrameWidth()
    return BlzGetLocalClientWidth() / BlzGetLocalClientHeight() * 0.6
end

function UpdateFullscreenCanvasSize()
    BlzFrameSetSize(fullscreenCanvasFrame.handle, GetScreenFrameWidth(), 0.6)
end

--- @type TextureFrame
leftSideIconFrame = nil
--- @type SimpleTextFrame
leftSideTextFrame = nil
--- @type SimpleTextFrame
leftSideStatisticsTextFrame = nil
--- @type TextureFrame
rightSideIconFrame = nil
--- @type SimpleTextFrame
rightSideTextFrame = nil
--- @type SimpleTextFrame
rightSideStatisticsTextFrame = nil


SIDE_FRAME_LEFT = 1
SIDE_FRAME_RIGHT = 2

upgradeFrames = {
    [SIDE_FRAME_LEFT] = {
        visible_total = 0,
        frames = {}
    },
    [SIDE_FRAME_RIGHT] = {
        visible_total = 0,
        frames = {}
    }
}


--- @type SimpleEmptyFrame
battleInfoWrapperFrame = nil
--- @type SimpleTextFrame
battleInfoLeftSideTitleFrame = nil
--- @type SimpleTextFrame
battleInfoRightSideTitleFrame = nil
--- @type SimpleTextFrame
battleInfoVersusLabelFrame = nil
--- @type TemplateBackdropFrame
battleWinnerBackdropFrame = nil
--- @type SimpleTextFrame
battleWinnerTextFrame = nil


TOTAL_UNIT_STATISTICS_BACKDROP_PADDING_X = 0.05
TOTAL_UNIT_STATISTICS_BACKDROP_PADDING_Y = 0.05
TOTAL_UNIT_STATISTICS_BACKDROP_HEIGHT = 0.4
--- @type TemplateBackdropFrame
totalUnitStatisticsBackdropFrame = nil

TOTAL_UNIT_STATISTICS_WRAPPER_PADDING_X = 0.025
TOTAL_UNIT_STATISTICS_WRAPPER_PADDING_Y = 0.025
--- @type SimpleEmptyFrame
totalUnitStatisticsWrapperFrame = nil

TOTAL_UNIT_STATISTICS_ICON_FRAME_WIDTH = 0.16
TOTAL_UNIT_STATISTICS_ICON_FRAME_HEIGHT = 0.036
TOTAL_UNIT_STATISTICS_ICON_SPACE_X_MIN = 0.01
TOTAL_UNIT_STATISTICS_ICON_SPACE_Y_MIN = 0.0075
TOTAL_UNIT_STATISTICS_APPEAR_DELAY = 0.1
TOTAL_UNIT_STATISTICS_FADING_IN_DURATION = 1

totalUnitStatisticsBattleListFrames = {}


TOTAL_BATTLES_STATISTICS_BACKDROP_PADDING_X = 0.025
TOTAL_BATTLES_STATISTICS_BACKDROP_PADDING_Y = 0.025
--- @type TemplateBackdropFrame
totalBattlesStatisticsBackdropFrame = nil

TOTAL_BATTLES_STATISTICS_WRAPPER_PADDING_X = 0.025
TOTAL_BATTLES_STATISTICS_WRAPPER_PADDING_Y = 0.025
--- @type SimpleEmptyFrame
totalBattlesStatisticsWrapperFrame = nil

--- @type SimpleEmptyFrame
totalBattlesStatisticsRacesWrapperFrame = nil
TOTAL_BATTLES_STATISTICS_RACE_WRAPPER_SPACE_Y = 0.01
TOTAL_BATTLES_STATISTICS_RACE_TEXT_SCALE = 2.5
TOTAL_BATTLES_STATISTICS_RACE_TEXT_HEIGHT = 0.0092 * TOTAL_BATTLES_STATISTICS_RACE_TEXT_SCALE
TOTAL_BATTLES_STATISTICS_RACE_TEXT_MARGIN_BOTTOM = 0.002 * TOTAL_BATTLES_STATISTICS_RACE_TEXT_SCALE

TOTAL_BATTLES_STATISTICS_ICON_FRAME_WIDTH = 0.12
TOTAL_BATTLES_STATISTICS_ICON_FRAME_HEIGHT = 0.027
TOTAL_BATTLES_STATISTICS_ICON_SPACE_X_MIN = 0.006
TOTAL_BATTLES_STATISTICS_ICON_SPACE_Y_MIN = 0.0075
TOTAL_BATTLES_STATISTICS_ICON_TEXT_BASE_SCALE = 1.8
TOTAL_BATTLES_STATISTICS_APPEAR_DELAY = 0.1
TOTAL_BATTLES_STATISTICS_FADING_IN_DURATION = 1

totalBattlesStatisticsBattleListFrames = {}

OnInit.map(function()
    -- Hide all unnecessary frames
    BlzHideOriginFrames(true)
    local framesToHide = {}
    for _, frameName in ipairs(FRAMES_TO_HIDE) do
        table.insert(framesToHide, BlzGetFrameByName(frameName, 0))
    end
    for _, frame in ipairs(framesToHide) do
        BlzFrameSetVisible(frame, false)
    end

    -- Creating fullscreen frame
    local mainFrame = BlzGetFrameByName("ConsoleUIBackdrop", 0)
    fullscreenWrapperFrame = SimpleEmptyFrame:new("FullscreenWrapper", mainFrame)
    fullscreenCanvasFrame = SimpleEmptyFrame:new("FullscreenCanvas", fullscreenWrapperFrame.handle)
    BlzFrameSetVisible(fullscreenCanvasFrame.handle, false)
    UpdateFullscreenCanvasSize()
    TimerStart(fullscreenCanvasTimer, FULLSCREEN_CANVAS_SIZE_REFRESH_PERIOD, true, UpdateFullscreenCanvasSize)
    BlzFrameSetAbsPoint(fullscreenCanvasFrame.handle, FRAMEPOINT_BOTTOM, 0.4, 0)

    leftSideIconFrame = TextureFrame:new("LeftSideIcon", "", fullscreenWrapperFrame.handle)
    leftSideIconFrame.cover:setSize(0.045, 0.045):setRelativePoint(FRAMEPOINT_TOPLEFT, fullscreenCanvasFrame.handle, FRAMEPOINT_TOPLEFT, 0.03, -0.03)
    leftSideTextFrame = SimpleTextFrame:new("LeftSideText", "0", 2, fullscreenWrapperFrame.handle)
    leftSideTextFrame:setRelativePoint(FRAMEPOINT_LEFT, leftSideIconFrame.cover.handle, FRAMEPOINT_RIGHT, 0.003, 0)
    leftSideStatisticsTextFrame = SimpleTextFrame:new("LeftSideStatisticsText", "Всего убито: 0|nВсего умерло: 0", 1.25, fullscreenWrapperFrame.handle)
    leftSideStatisticsTextFrame:setRelativePoint(FRAMEPOINT_LEFT, leftSideTextFrame.handle, FRAMEPOINT_RIGHT, 0.01, 0):setRelativePoint(FRAMEPOINT_TOP, leftSideIconFrame.cover.handle, FRAMEPOINT_TOP, 0, 0):setAlignment(TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_LEFT)

    rightSideIconFrame = TextureFrame:new("RightSideIcon", "", fullscreenWrapperFrame.handle)
    rightSideIconFrame.cover:setSize(0.045, 0.045):setRelativePoint(FRAMEPOINT_TOPRIGHT, fullscreenCanvasFrame.handle, FRAMEPOINT_TOPRIGHT, -0.03, -0.03)
    rightSideTextFrame = SimpleTextFrame:new("RightSideText", "0", 2, fullscreenWrapperFrame.handle)
    rightSideTextFrame:setRelativePoint(FRAMEPOINT_RIGHT, rightSideIconFrame.cover.handle, FRAMEPOINT_LEFT, -0.003, 0)
    rightSideStatisticsTextFrame = SimpleTextFrame:new("RightSideStatisticsText", "Всего убито: 0|nВсего умерло: 0", 1.25, fullscreenWrapperFrame.handle)
    rightSideStatisticsTextFrame:setRelativePoint(FRAMEPOINT_RIGHT, rightSideTextFrame.handle, FRAMEPOINT_LEFT, -0.01, 0):setRelativePoint(FRAMEPOINT_TOP, rightSideIconFrame.cover.handle, FRAMEPOINT_TOP, 0, 0):setAlignment(TEXT_JUSTIFY_TOP, TEXT_JUSTIFY_RIGHT)

    battleInfoWrapperFrame = SimpleTypeFrame:new("BattleInfoWrapper", "SPRITE", fullscreenWrapperFrame.handle, "", 0)
    battleInfoWrapperFrame:setSize(0.3, 0):setRelativePoint(FRAMEPOINT_TOP, fullscreenCanvasFrame.handle, FRAMEPOINT_TOP, 0, 0):setRelativePoint(FRAMEPOINT_BOTTOM, fullscreenCanvasFrame.handle, FRAMEPOINT_BOTTOM, 0, 0)
    battleInfoLeftSideTitleFrame = SimpleTextFrame:new("BattleInfoLeftSideTitle", "", 3, battleInfoWrapperFrame.handle)
    battleInfoLeftSideTitleFrame:setRelativePoint(FRAMEPOINT_TOP, battleInfoWrapperFrame.handle, FRAMEPOINT_TOP, 0, -0.006)
    battleInfoVersusLabelFrame = SimpleTextFrame:new("BattleInfoVersusLabel", "против", 2.6, battleInfoWrapperFrame.handle)
    battleInfoVersusLabelFrame:setRelativePoint(FRAMEPOINT_TOP, battleInfoLeftSideTitleFrame.handle, FRAMEPOINT_BOTTOM, 0, -0.004)
    battleInfoRightSideTitleFrame = SimpleTextFrame:new("BattleInfoRightSideTitle", "", 3, battleInfoWrapperFrame.handle)
    battleInfoRightSideTitleFrame:setRelativePoint(FRAMEPOINT_TOP, battleInfoVersusLabelFrame.handle, FRAMEPOINT_BOTTOM, 0, -0.004)
    battleInfoWrapperFrame:setVisible(false)

    battleWinnerBackdropFrame = TemplateBackdropFrame:new("BattleWinnerBackdrop", "QuestButtonBaseTemplate", fullscreenWrapperFrame.handle)
    battleWinnerTextFrame = SimpleTextFrame:new("BattleWinnerText", "", 4, battleWinnerBackdropFrame.cover.handle)
    battleWinnerTextFrame:setAlignment(TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
    battleWinnerBackdropFrame.cover:setAbsPoint(FRAMEPOINT_CENTER, 0.4, 0.3):setSize(0.4, 0):setVisible(false)
    battleWinnerTextFrame
        :setRelativePoint(FRAMEPOINT_TOP, battleWinnerBackdropFrame.cover.handle, FRAMEPOINT_TOP, 0, -0.1)
        :setRelativePoint(FRAMEPOINT_BOTTOM, battleWinnerBackdropFrame.cover.handle, FRAMEPOINT_BOTTOM, 0, 0.1)
        :setRelativePoint(FRAMEPOINT_LEFT, battleWinnerBackdropFrame.cover.handle, FRAMEPOINT_LEFT, 0.005, 0)
        :setRelativePoint(FRAMEPOINT_RIGHT, battleWinnerBackdropFrame.cover.handle, FRAMEPOINT_RIGHT, -0.005, 0)
        :setVisible(false)

    totalUnitStatisticsBackdropFrame = TemplateBackdropFrame:new("TotalUnitStatisticsBackdrop", "EscMenuBackdrop", fullscreenWrapperFrame.handle)
    totalUnitStatisticsBackdropFrame.cover
        :setRelativePoint(FRAMEPOINT_BOTTOMLEFT, fullscreenCanvasFrame.handle, FRAMEPOINT_BOTTOMLEFT, TOTAL_UNIT_STATISTICS_BACKDROP_PADDING_X, TOTAL_UNIT_STATISTICS_BACKDROP_PADDING_Y)
        :setRelativePoint(FRAMEPOINT_BOTTOMRIGHT, fullscreenCanvasFrame.handle, FRAMEPOINT_BOTTOMRIGHT, -TOTAL_UNIT_STATISTICS_BACKDROP_PADDING_X, TOTAL_UNIT_STATISTICS_BACKDROP_PADDING_Y)
        :setSize(0, TOTAL_UNIT_STATISTICS_BACKDROP_HEIGHT)
        :setVisible(false)
    totalUnitStatisticsWrapperFrame = SimpleEmptyFrame:new("TotalUnitStatisticsWrapper", totalUnitStatisticsBackdropFrame.cover.handle)
    totalUnitStatisticsWrapperFrame
        :setRelativePoint(FRAMEPOINT_TOPLEFT, totalUnitStatisticsBackdropFrame.cover.handle, FRAMEPOINT_TOPLEFT, TOTAL_UNIT_STATISTICS_WRAPPER_PADDING_X, -TOTAL_UNIT_STATISTICS_WRAPPER_PADDING_Y)
        :setRelativePoint(FRAMEPOINT_TOPRIGHT, totalUnitStatisticsBackdropFrame.cover.handle, FRAMEPOINT_TOPRIGHT, -TOTAL_UNIT_STATISTICS_WRAPPER_PADDING_X, -TOTAL_UNIT_STATISTICS_WRAPPER_PADDING_Y)
        :setRelativePoint(FRAMEPOINT_BOTTOM, totalUnitStatisticsBackdropFrame.cover.handle, FRAMEPOINT_BOTTOM, 0, TOTAL_UNIT_STATISTICS_WRAPPER_PADDING_Y)

    totalBattlesStatisticsBackdropFrame = TemplateBackdropFrame:new("TotalBattlesStatisticsBackdrop", "EscMenuBackdrop", fullscreenWrapperFrame.handle)
    totalBattlesStatisticsBackdropFrame.cover
        :setRelativePoint(FRAMEPOINT_BOTTOMLEFT, fullscreenCanvasFrame.handle, FRAMEPOINT_BOTTOMLEFT, TOTAL_BATTLES_STATISTICS_BACKDROP_PADDING_X, TOTAL_BATTLES_STATISTICS_BACKDROP_PADDING_Y)
        :setRelativePoint(FRAMEPOINT_BOTTOMRIGHT, fullscreenCanvasFrame.handle, FRAMEPOINT_BOTTOMRIGHT, -TOTAL_BATTLES_STATISTICS_BACKDROP_PADDING_X, TOTAL_BATTLES_STATISTICS_BACKDROP_PADDING_Y)
        :setRelativePoint(FRAMEPOINT_TOPLEFT, fullscreenCanvasFrame.handle, FRAMEPOINT_TOPLEFT, TOTAL_BATTLES_STATISTICS_BACKDROP_PADDING_X, -TOTAL_BATTLES_STATISTICS_BACKDROP_PADDING_Y)
        :setRelativePoint(FRAMEPOINT_TOPRIGHT, fullscreenCanvasFrame.handle, FRAMEPOINT_TOPRIGHT, -TOTAL_BATTLES_STATISTICS_BACKDROP_PADDING_X, -TOTAL_BATTLES_STATISTICS_BACKDROP_PADDING_Y)
        --:setVisible(false)
    totalBattlesStatisticsWrapperFrame = SimpleEmptyFrame:new("TotalBattlesStatisticsWrapper", totalBattlesStatisticsBackdropFrame.cover.handle)
    totalBattlesStatisticsWrapperFrame
        :setRelativePoint(FRAMEPOINT_TOPLEFT, totalBattlesStatisticsBackdropFrame.cover.handle, FRAMEPOINT_TOPLEFT, TOTAL_BATTLES_STATISTICS_WRAPPER_PADDING_X, -TOTAL_BATTLES_STATISTICS_WRAPPER_PADDING_Y)
        :setRelativePoint(FRAMEPOINT_TOPRIGHT, totalBattlesStatisticsBackdropFrame.cover.handle, FRAMEPOINT_TOPRIGHT, -TOTAL_BATTLES_STATISTICS_WRAPPER_PADDING_X, -TOTAL_BATTLES_STATISTICS_WRAPPER_PADDING_Y)
        :setRelativePoint(FRAMEPOINT_BOTTOM, totalBattlesStatisticsBackdropFrame.cover.handle, FRAMEPOINT_BOTTOM, 0, TOTAL_BATTLES_STATISTICS_WRAPPER_PADDING_Y)
    totalBattlesStatisticsRacesWrapperFrame = SimpleEmptyFrame:new("TotalBattlesStatisticsRacesWrapper", totalBattlesStatisticsWrapperFrame.handle)
    totalBattlesStatisticsRacesWrapperFrame:setAllPoints(totalBattlesStatisticsWrapperFrame.handle):setVisible(false)

    BlzFrameClearAllPoints(mainFrame)
end)

function ClearUpgradeFrames()
    for _, sideUpgradeFrames in ipairs(upgradeFrames) do
        ---@param upgradeFrame SimpleTypeFrame
        for _, upgradeFrame in ipairs(sideUpgradeFrames.frames) do
            upgradeFrame:setVisible(false)
        end
        sideUpgradeFrames.visible_total = 0
    end
end

function AppendUpgradeFrame(side)
    local frameIndex = upgradeFrames[side].visible_total + 1
    ---@type UpgradeDataFrame
    local upgradeFrame = upgradeFrames[side].frames[frameIndex]
    if (upgradeFrame == nil) then
        upgradeFrame = UpgradeDataFrame:new("UpgradeFrameContainer", "", "0", 1.25, side == SIDE_FRAME_LEFT and UPGRADE_DATA_FRAME_TEXT_ALIGNMENT_RIGHT or UPGRADE_DATA_FRAME_TEXT_ALIGNMENT_LEFT, fullscreenWrapperFrame.handle, frameIndex - 1)
        upgradeFrame:setSize(0.034, 0.0225)
        upgradeFrames[side].frames[frameIndex] = upgradeFrame
        if frameIndex == 1 then
            upgradeFrame.cover:setRelativePoint(side == SIDE_FRAME_LEFT and FRAMEPOINT_TOPLEFT or FRAMEPOINT_TOPRIGHT, side == SIDE_FRAME_LEFT and leftSideIconFrame.cover.handle or rightSideIconFrame.cover.handle, side == SIDE_FRAME_LEFT and FRAMEPOINT_BOTTOMLEFT or FRAMEPOINT_BOTTOMRIGHT, 0, -0.015)
        elseif (frameIndex - 1) % 4 == 0 then
            upgradeFrame.cover:setRelativePoint(side == SIDE_FRAME_LEFT and FRAMEPOINT_TOPLEFT or FRAMEPOINT_TOPRIGHT, upgradeFrames[side].frames[frameIndex - 4].cover.handle, side == SIDE_FRAME_LEFT and FRAMEPOINT_BOTTOMLEFT or FRAMEPOINT_BOTTOMRIGHT, 0, -0.003)
        else
            upgradeFrame.cover:setRelativePoint(side == SIDE_FRAME_LEFT and FRAMEPOINT_LEFT or FRAMEPOINT_RIGHT, upgradeFrames[side].frames[frameIndex - 1].cover.handle, side == SIDE_FRAME_LEFT and FRAMEPOINT_RIGHT or FRAMEPOINT_LEFT, side == SIDE_FRAME_LEFT and 0.001 or -0.001, 0)
        end
    else
        upgradeFrame:setVisible(true)
    end
    upgradeFrames[side].visible_total = frameIndex
end

function ShowStatisticsFrame(battles, onFinishCallback)
    totalUnitStatisticsBackdropFrame.cover:setAlpha(255):setVisible(true)
    local frameSpaceWidth = GetScreenFrameWidth() - TOTAL_UNIT_STATISTICS_BACKDROP_PADDING_X * 2 - TOTAL_UNIT_STATISTICS_WRAPPER_PADDING_X * 2
    local frameSpaceHeight = TOTAL_UNIT_STATISTICS_BACKDROP_HEIGHT - TOTAL_UNIT_STATISTICS_WRAPPER_PADDING_Y * 2
    local iconFramesPerRow = math.floor((frameSpaceWidth + TOTAL_UNIT_STATISTICS_ICON_SPACE_X_MIN) / (TOTAL_UNIT_STATISTICS_ICON_FRAME_WIDTH + TOTAL_UNIT_STATISTICS_ICON_SPACE_X_MIN))
    local iconFramesPerCol = math.floor((frameSpaceHeight + TOTAL_UNIT_STATISTICS_ICON_SPACE_Y_MIN) / (TOTAL_UNIT_STATISTICS_ICON_FRAME_HEIGHT + TOTAL_UNIT_STATISTICS_ICON_SPACE_Y_MIN))
    local totalIconsWidth = iconFramesPerRow * TOTAL_UNIT_STATISTICS_ICON_FRAME_WIDTH
    local totalIconsHeight = iconFramesPerCol * TOTAL_UNIT_STATISTICS_ICON_FRAME_HEIGHT
    local finalIconFrameHorizontalSpaceBetween = (frameSpaceWidth - totalIconsWidth) / (iconFramesPerRow - 1)
    local finalIconFrameVerticalSpaceBetween = (frameSpaceHeight - totalIconsHeight) / (iconFramesPerCol - 1)
    for i, battle in ipairs(battles) do
        DelayCallback(TOTAL_UNIT_STATISTICS_APPEAR_DELAY * i, function()
            local wrapperFrame
            local iconFrame
            local textFrame
            if totalUnitStatisticsBattleListFrames[i] == nil then
                wrapperFrame = SimpleEmptyFrame:new("TotalUnitStatisticsEntryWrapper", totalUnitStatisticsBackdropFrame.cover.handle, i)
                iconFrame = TextureFrame:new("TotalUnitStatisticsEntryIcon", "", wrapperFrame.handle, i)
                textFrame = SimpleTextFrame:new("TotalUnitStatisticsEntryText", "", 2.25 * (TOTAL_UNIT_STATISTICS_ICON_FRAME_HEIGHT / 0.06), wrapperFrame.handle, i)
                wrapperFrame
                    :setSize(TOTAL_UNIT_STATISTICS_ICON_FRAME_WIDTH, TOTAL_UNIT_STATISTICS_ICON_FRAME_HEIGHT)
                iconFrame.cover
                    :setSize(TOTAL_UNIT_STATISTICS_ICON_FRAME_HEIGHT, TOTAL_UNIT_STATISTICS_ICON_FRAME_HEIGHT)
                    :setRelativePoint(FRAMEPOINT_TOPLEFT, wrapperFrame.handle, FRAMEPOINT_TOPLEFT, 0, 0)
                    :setRelativePoint(FRAMEPOINT_BOTTOMLEFT, wrapperFrame.handle, FRAMEPOINT_BOTTOMLEFT, 0, 0)
                textFrame
                    :setRelativePoint(FRAMEPOINT_TOPLEFT, iconFrame.cover.handle, FRAMEPOINT_TOPRIGHT, 0.003, 0)
                    :setRelativePoint(FRAMEPOINT_BOTTOMLEFT, iconFrame.cover.handle, FRAMEPOINT_BOTTOMLEFT, 0.003, 0)
                    :setRelativePoint(FRAMEPOINT_TOPRIGHT, wrapperFrame.handle, FRAMEPOINT_TOPRIGHT, 0, 0)
                    :setRelativePoint(FRAMEPOINT_BOTTOMRIGHT, wrapperFrame.handle, FRAMEPOINT_BOTTOMRIGHT, 0, 0)
                    :setAlignment(TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
                totalUnitStatisticsBattleListFrames[i] = {
                    wrapper = wrapperFrame,
                    icon = iconFrame,
                    text = textFrame
                }
            else
                wrapperFrame = totalUnitStatisticsBattleListFrames[i].wrapper
                iconFrame = totalUnitStatisticsBattleListFrames[i].icon
                textFrame = totalUnitStatisticsBattleListFrames[i].text
            end
            iconFrame:setTexture(battle.enemy.icon)
            textFrame
                :setText(battle.enemy.name .. "\n" .. (battle.is_winner and "Победа" or "Поражение") .. " (" .. battle.units_left .. ")")
                :setColor(battle.is_winner and 0 or 255, battle.is_winner and 255 or 0, 0)
            if i == 1 then
                wrapperFrame:setRelativePoint(FRAMEPOINT_TOPLEFT, totalUnitStatisticsWrapperFrame.handle, FRAMEPOINT_TOPLEFT, 0, 0)
            elseif (i - 1) % iconFramesPerRow == 0 then
                if (i - 1) / iconFramesPerRow > iconFramesPerCol - 1 then
                    for j = i - (iconFramesPerRow * iconFramesPerCol), i - (iconFramesPerRow * iconFramesPerCol) + iconFramesPerRow - 1 do
                        totalUnitStatisticsBattleListFrames[j].wrapper:setVisible(false):resetPoints()
                    end
                    totalUnitStatisticsBattleListFrames[i - (iconFramesPerRow * iconFramesPerCol) + iconFramesPerRow].wrapper:setRelativePoint(FRAMEPOINT_TOPLEFT, totalUnitStatisticsWrapperFrame.handle, FRAMEPOINT_TOPLEFT, 0, 0)
                end
                wrapperFrame:setRelativePoint(FRAMEPOINT_TOPLEFT, totalUnitStatisticsBattleListFrames[i - iconFramesPerRow].wrapper.handle, FRAMEPOINT_BOTTOMLEFT, 0, -finalIconFrameVerticalSpaceBetween)
            else
                wrapperFrame:setRelativePoint(FRAMEPOINT_TOPLEFT, totalUnitStatisticsBattleListFrames[i - 1].wrapper.handle, FRAMEPOINT_TOPRIGHT, finalIconFrameHorizontalSpaceBetween, 0)
            end
            wrapperFrame:animateFadeIn(TOTAL_UNIT_STATISTICS_FADING_IN_DURATION, function()
                if i >= #battles then
                    onFinishCallback()
                end
            end)
        end)
    end
end

function HideStatisticsFrame(onFinishCallback)
    totalUnitStatisticsBackdropFrame.cover:animateFadeOut(0.5, function()
        for _, iconFrame in ipairs(totalUnitStatisticsBattleListFrames) do
            iconFrame.wrapper:setVisible(false):resetPoints()
        end
        onFinishCallback()
    end)
end

function ShowFinalRacesFrame(raceSummary)
    totalBattlesStatisticsBackdropFrame.cover:setAlpha(255):setVisible(true)
    local frameSpaceWidth = GetScreenFrameWidth() - TOTAL_BATTLES_STATISTICS_BACKDROP_PADDING_X * 2 - TOTAL_BATTLES_STATISTICS_WRAPPER_PADDING_X * 2
    local iconFramesPerRow = math.floor((frameSpaceWidth + TOTAL_BATTLES_STATISTICS_ICON_SPACE_X_MIN) / (TOTAL_BATTLES_STATISTICS_ICON_FRAME_WIDTH + TOTAL_BATTLES_STATISTICS_ICON_SPACE_X_MIN))
    local totalIconsWidth = iconFramesPerRow * TOTAL_BATTLES_STATISTICS_ICON_FRAME_WIDTH
    local finalIconFrameHorizontalSpaceBetween = (frameSpaceWidth - totalIconsWidth) / (iconFramesPerRow - 1)
    for i, race in ipairs(raceSummary) do
        local raceWrapperFrameHeight = TOTAL_BATTLES_STATISTICS_RACE_TEXT_HEIGHT
        local raceWrapperFrame
        local raceTextFrame
        local raceIcons
        if totalBattlesStatisticsBattleListFrames[i] == nil then
            raceWrapperFrame = SimpleEmptyFrame:new("TotalBattlesStatisticsRaceWrapper", totalBattlesStatisticsRacesWrapperFrame.handle, i)
            raceTextFrame = SimpleTextFrame:new("TotalBattlesStatisticsRaceText", "", TOTAL_BATTLES_STATISTICS_RACE_TEXT_SCALE, raceWrapperFrame.handle, i)
            raceTextFrame:setRelativePoint(FRAMEPOINT_TOPLEFT, raceWrapperFrame.handle, FRAMEPOINT_TOPLEFT, 0, 0)
            raceIcons = {}
            totalBattlesStatisticsBattleListFrames[i] = {
                wrapper = raceWrapperFrame,
                text = raceTextFrame,
                icons = raceIcons
            }
        else
            raceWrapperFrame = totalBattlesStatisticsBattleListFrames[i].wrapper
            raceTextFrame = totalBattlesStatisticsBattleListFrames[i].text
            raceIcons = totalBattlesStatisticsBattleListFrames[i].icons
        end
        raceTextFrame:setText("|cffffcc00" .. race.race .. "|r")
        if i == 1 then
            raceWrapperFrame
                :setRelativePoint(FRAMEPOINT_TOPLEFT, totalBattlesStatisticsRacesWrapperFrame.handle, FRAMEPOINT_TOPLEFT, 0, 0)
                :setRelativePoint(FRAMEPOINT_TOPRIGHT, totalBattlesStatisticsRacesWrapperFrame.handle, FRAMEPOINT_TOPRIGHT, 0, 0)
        else
            raceWrapperFrame
                :setRelativePoint(FRAMEPOINT_TOPLEFT, totalBattlesStatisticsBattleListFrames[i - 1].wrapper.handle, FRAMEPOINT_BOTTOMLEFT, 0, -TOTAL_BATTLES_STATISTICS_RACE_WRAPPER_SPACE_Y)
                :setRelativePoint(FRAMEPOINT_TOPRIGHT, totalBattlesStatisticsBattleListFrames[i - 1].wrapper.handle, FRAMEPOINT_BOTTOMRIGHT, 0, -TOTAL_BATTLES_STATISTICS_RACE_WRAPPER_SPACE_Y)
        end
        for j, unit in ipairs(race.units) do
            local wrapperFrame
            local iconFrame
            local textFrame
            if raceIcons[j] == nil then
                wrapperFrame = SimpleEmptyFrame:new("TotalBattlesStatisticsEntryWrapper", raceWrapperFrame.handle, j)
                iconFrame = TextureFrame:new("TotalBattlesStatisticsEntryIcon", "", wrapperFrame.handle, j)
                textFrame = SimpleTextFrame:new("TotalBattlesStatisticsEntryText", "", TOTAL_BATTLES_STATISTICS_ICON_TEXT_BASE_SCALE * (TOTAL_BATTLES_STATISTICS_ICON_FRAME_HEIGHT / 0.06), wrapperFrame.handle, j)
                wrapperFrame
                    :setSize(TOTAL_BATTLES_STATISTICS_ICON_FRAME_WIDTH, TOTAL_BATTLES_STATISTICS_ICON_FRAME_HEIGHT)
                iconFrame.cover
                    :setSize(TOTAL_BATTLES_STATISTICS_ICON_FRAME_HEIGHT, TOTAL_BATTLES_STATISTICS_ICON_FRAME_HEIGHT)
                    :setRelativePoint(FRAMEPOINT_TOPLEFT, wrapperFrame.handle, FRAMEPOINT_TOPLEFT, 0, 0)
                    :setRelativePoint(FRAMEPOINT_BOTTOMLEFT, wrapperFrame.handle, FRAMEPOINT_BOTTOMLEFT, 0, 0)
                textFrame
                    :setRelativePoint(FRAMEPOINT_TOPLEFT, iconFrame.cover.handle, FRAMEPOINT_TOPRIGHT, 0.002, 0)
                    :setRelativePoint(FRAMEPOINT_BOTTOMLEFT, iconFrame.cover.handle, FRAMEPOINT_BOTTOMLEFT, 0.002, 0)
                    :setRelativePoint(FRAMEPOINT_TOPRIGHT, wrapperFrame.handle, FRAMEPOINT_TOPRIGHT, 0, 0)
                    :setRelativePoint(FRAMEPOINT_BOTTOMRIGHT, wrapperFrame.handle, FRAMEPOINT_BOTTOMRIGHT, 0, 0)
                    :setAlignment(TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_CENTER)
                raceIcons[j] = {
                    wrapper = wrapperFrame,
                    icon = iconFrame,
                    text = textFrame
                }
            else
                wrapperFrame = raceIcons[j].wrapper
                iconFrame = raceIcons[j].icon
                textFrame = raceIcons[j].text
            end
            iconFrame:setTexture(unit.icon)
            local victoryPercentage = 0
            if unit.battles > 0 then
                victoryPercentage = unit.victories / unit.battles * 100
            end
            textFrame:setText(unit.name .. "\n" .. "Побед: " .. unit.victories .. "/" .. unit.battles .. " (" .. string.format("%.2f", victoryPercentage) .. "%)")
            if j == 1 then
                wrapperFrame:setRelativePoint(FRAMEPOINT_TOPLEFT, raceTextFrame.handle, FRAMEPOINT_BOTTOMLEFT, 0, -TOTAL_BATTLES_STATISTICS_RACE_TEXT_MARGIN_BOTTOM)
                raceWrapperFrameHeight = raceWrapperFrameHeight + TOTAL_BATTLES_STATISTICS_ICON_FRAME_HEIGHT + TOTAL_BATTLES_STATISTICS_RACE_TEXT_MARGIN_BOTTOM
            elseif (j - 1) % iconFramesPerRow == 0 then
                wrapperFrame:setRelativePoint(FRAMEPOINT_TOPLEFT, raceIcons[j - iconFramesPerRow].wrapper.handle, FRAMEPOINT_BOTTOMLEFT, 0, -TOTAL_UNIT_STATISTICS_ICON_SPACE_Y_MIN)
                raceWrapperFrameHeight = raceWrapperFrameHeight + TOTAL_BATTLES_STATISTICS_ICON_FRAME_HEIGHT + TOTAL_UNIT_STATISTICS_ICON_SPACE_Y_MIN
            else
                wrapperFrame:setRelativePoint(FRAMEPOINT_TOPLEFT, raceIcons[j - 1].wrapper.handle, FRAMEPOINT_TOPRIGHT, finalIconFrameHorizontalSpaceBetween, 0)
            end
        end
        raceWrapperFrame:setSize(0, raceWrapperFrameHeight)
    end
    totalBattlesStatisticsRacesWrapperFrame:animateFadeIn(1.5)
end
---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by WGPavell.
--- DateTime: 22.03.2025 12:29
---

FOOD_LIMIT = 100
SPAWN_CENTER_DISTANCE = 1500
SPAWN_RADIUS_WIDTH = 1000
SPAWN_RADIUS_HEIGHT = 1500
SPAWN_LEFT = 1
SPAWN_RIGHT = 2

battleUnitsLeft = {
    [SPAWN_LEFT] = 0,
    [SPAWN_RIGHT] = 0
}

battleUnitDefeatTrg = nil
battleUnitHelperSummonTrg = nil
battleUnitTemporaryDisableSpiritFormTrg = nil
battleUnitsGroup = CreateGroup()
sideGroups = {
    [SPAWN_LEFT] = CreateGroup(),
    [SPAWN_RIGHT] = CreateGroup()
}
sideHelperUnits = {}

leftSideSpawnData = {
    raceIndex = 2,
    unitIndex = 8
}
rightSideSpawnData = {
    raceIndex = 1,
    unitIndex = 7
}

sideFrames = nil

battleSideFrames = nil
isWinningFrameAppearing = false

function generateGridForSpawn(centerX, angle, unitsTotal)
    local directionDiff = math.cos(math.rad(angle))
    local left = (centerX - (SPAWN_RADIUS_WIDTH / 2)  * directionDiff)
    local bottom = -SPAWN_RADIUS_HEIGHT / 2
    --AddSpecialEffect("Abilities\\Spells\\Human\\DevotionAura\\DevotionAura.mdl", left, bottom)
    --AddSpecialEffect("Abilities\\Spells\\Human\\DevotionAura\\DevotionAura.mdl", left, bottom + SPAWN_RADIUS_HEIGHT)
    --AddSpecialEffect("Abilities\\Spells\\Human\\DevotionAura\\DevotionAura.mdl", left + SPAWN_RADIUS_WIDTH * directionDiff, bottom + SPAWN_RADIUS_HEIGHT)
    --AddSpecialEffect("Abilities\\Spells\\Human\\DevotionAura\\DevotionAura.mdl", left + SPAWN_RADIUS_WIDTH * directionDiff, bottom)
    local bestCols = math.floor(math.sqrt(unitsTotal))
    if unitsTotal % bestCols ~= 0 then
        bestCols = math.max(math.floor(math.sqrt(unitsTotal * SPAWN_RADIUS_WIDTH / SPAWN_RADIUS_HEIGHT)), 1)
        while unitsTotal % bestCols ~= 0 do
            bestCols = bestCols - 1
        end
    end
    local bestRows = math.floor(unitsTotal / bestCols)
    local dx = bestCols > 1 and SPAWN_RADIUS_WIDTH / (bestCols - 1) * directionDiff or 0
    local dy = bestRows > 1 and SPAWN_RADIUS_HEIGHT / (bestRows - 1) or 0
    local points = {}
    for i = 1, bestRows do
        local y = dy ~= 0 and bottom + (i - 1) * dy or 0
        for j = 1, bestCols do
            local x = dx ~= 0 and left + (j - 1) * dx or centerX
            table.insert(points, {
                x = x,
                y = y
            })
        end
    end
    return points
end

unitsInBattle = {}

---@param unitData table
---@param spawnSide number
function CreateUnitStack(unitData, spawnSide)
    local forPlayer = Player(spawnSide == SPAWN_LEFT and 1 or 2)
    --local forPlayer = Player(0)
    local unitsTotal = math.floor(FOOD_LIMIT / unitData.food_cost)
    --local unitsTotal = 1
    battleUnitsLeft[spawnSide] = unitsTotal

    sideFrames[spawnSide].icon:setTexture(unitData.icon)
    sideFrames[spawnSide].text:setText(tostring(unitsTotal))
    battleSideFrames[spawnSide]:setText("|cffffcc00" .. unitData.name .. " [" .. unitsTotal .. "]|r")

    if not unitData.is_hero and unitsUpgradesDependencies[unitData.code] ~= nil then
        for index, upgrade in ipairs(unitsUpgradesDependencies[unitData.code]) do
            local upgradeLevel = GetPlayerTechMaxAllowed(forPlayer, FourCC(upgrade.code))
            SetPlayerTechResearched(forPlayer, FourCC(upgrade.code), upgradeLevel)
            AppendUpgradeFrame(spawnSide)
            upgradeFrames[spawnSide].frames[index]:setIconPath(upgrade.icon)
            upgradeFrames[spawnSide].frames[index]:setText(upgradeLevel)
        end
    end

    local centerPointX = SPAWN_CENTER_DISTANCE * (spawnSide == SPAWN_LEFT and -1 or 1)
    local spawnAngle = spawnSide == SPAWN_LEFT and 0 or 180
    local gridPoints = generateGridForSpawn(centerPointX, spawnAngle, unitsTotal)
    local spawnedUnits = {}
    local isHeroAbilityFramesAppended = false
    for _, point in ipairs(gridPoints) do
        local unit = CreateUnit(forPlayer, FourCC(unitData.code), point.x, point.y, spawnAngle)
        unitsInBattle[unit] = spawnSide
        --RemoveGuardPosition(unit)
        GroupAddUnit(battleUnitsGroup, unit)
        GroupAddUnit(sideGroups[spawnSide], unit)
        TriggerRegisterUnitEvent(battleUnitDefeatTrg, unit, EVENT_UNIT_DEATH)
        TriggerRegisterUnitEvent(battleUnitDefeatTrg, unit, EVENT_UNIT_CHANGE_OWNER)
        table.insert(spawnedUnits, unit)
        if unitData.is_hero then
            SetHeroLevel(unit, 10, false)
            if heroAbilities[unitData.code] ~= nil then
                for abilityIndex, ability in ipairs(heroAbilities[unitData.code]) do
                    local prevLevel
                    repeat
                        prevLevel = GetUnitAbilityLevel(unit, FourCC(ability))
                        SelectHeroSkill(unit, FourCC(ability))
                    until prevLevel == GetUnitAbilityLevel(unit, FourCC(ability))
                    if not isHeroAbilityFramesAppended then
                        AppendUpgradeFrame(spawnSide)
                        upgradeFrames[spawnSide].frames[abilityIndex]:setIconPath(abilitiesIcons[ability])
                        upgradeFrames[spawnSide].frames[abilityIndex]:setText(prevLevel)
                    end
                end
            end
            isHeroAbilityFramesAppended = true
        end
        --SetWidgetLife(unit, 1)
        SetUnitState(unit, UNIT_STATE_MANA, GetUnitState(unit, UNIT_STATE_MAX_MANA))
    end
    return spawnedUnits
end

function PrepareNewBattle()
    PauseTimer(sideUnitsAttackRecycleTimer)
    PauseTimer(centerCameraTimer)

    ForGroup(battleUnitsGroup, function()
        GroupRemoveUnit(battleUnitsGroup, GetEnumUnit())
        RemoveUnit(GetEnumUnit())
    end)
    local leftUnitsGroup = CreateGroup()
    GroupEnumUnitsInRect(leftUnitsGroup, GetPlayableMapRect(), nil)
    ForGroup(leftUnitsGroup, function()
        RemoveUnit(GetEnumUnit())
    end)
    GroupClear(leftUnitsGroup)
    DestroyGroup(leftUnitsGroup)

    ClearUpgradeFrames()

    local prevLeftSideData = unitList[leftSideSpawnData.raceIndex].units[leftSideSpawnData.unitIndex]

    repeat
        rightSideSpawnData.unitIndex = rightSideSpawnData.unitIndex + 1
        repeat
            --debugPrint("New iteration")
            if unitList[rightSideSpawnData.raceIndex].units[rightSideSpawnData.unitIndex] == nil then
--                debugPrint("No units left in race for right side, so switch to next race")
                rightSideSpawnData.raceIndex = rightSideSpawnData.raceIndex + 1
                rightSideSpawnData.unitIndex = 1
                if unitList[rightSideSpawnData.raceIndex] == nil then
--                    debugPrint("No units left for right side, so switch unit for left side")
                    leftSideSpawnData.unitIndex = leftSideSpawnData.unitIndex + 1
                    if unitList[leftSideSpawnData.raceIndex].units[leftSideSpawnData.unitIndex] == nil then
--                        debugPrint("No units left in race for left side, so switch to next race")
                        leftSideSpawnData.raceIndex = leftSideSpawnData.raceIndex + 1
                        if unitList[leftSideSpawnData.raceIndex] == nil then
--                            debugPrint("All battles done")
                            return
                        end
                        leftSideSpawnData.unitIndex = 1
                    end
                    rightSideSpawnData.raceIndex = leftSideSpawnData.raceIndex
                    rightSideSpawnData.unitIndex = leftSideSpawnData.unitIndex + 1
                end
            end
        until unitList[rightSideSpawnData.raceIndex].units[rightSideSpawnData.unitIndex] ~= nil
        --debugPrint("Left side - " .. leftSideSpawnData.raceIndex .. ":" .. leftSideSpawnData.unitIndex)
        local leftUnitData = unitList[leftSideSpawnData.raceIndex].units[leftSideSpawnData.unitIndex]
--        debugPrint("Right side - " .. rightSideSpawnData.raceIndex .. ":" .. rightSideSpawnData.unitIndex)
        local rightUnitData = unitList[rightSideSpawnData.raceIndex].units[rightSideSpawnData.unitIndex]
--        debugPrint("Left side name " .. leftUnitData.name)
--        debugPrint("Right side name " .. rightUnitData.name)
        local leftCanAttackRight = ((leftUnitData.attack_target.ground and rightUnitData.unit_target.ground) or (leftUnitData.attack_target.air and rightUnitData.unit_target.air)) and not (leftUnitData.attack_target.magic and rightUnitData.unit_target.immune)
--        debugPrint(leftCanAttackRight and "Left can attack right" or "Left can't attack right")
        local rightCanAttackLeft = (rightUnitData.attack_target.ground and leftUnitData.unit_target.ground) or (rightUnitData.attack_target.air and leftUnitData.unit_target.air) and not (rightUnitData.attack_target.magic and leftUnitData.unit_target.immune)
--        debugPrint(rightCanAttackLeft and "Right can attack left" or "Right can't attack left")
    until leftCanAttackRight and rightCanAttackLeft and leftUnitData.is_hero == rightUnitData.is_hero

    local leftSideUnitData = unitList[leftSideSpawnData.raceIndex].units[leftSideSpawnData.unitIndex]
    if prevLeftSideData ~= leftSideUnitData then
        ShowStatisticsFrame(prevLeftSideData.history, function()
            DelayCallback(5, function()
                HideStatisticsFrame(function()
                    StartNewBattle()
                end)
            end)
        end)
    else
        StartNewBattle()
    end
end

function StartNewBattle()
    local leftSideUnitData = unitList[leftSideSpawnData.raceIndex].units[leftSideSpawnData.unitIndex]
    local rightSideUnitData = unitList[rightSideSpawnData.raceIndex].units[rightSideSpawnData.unitIndex]
    local leftSideUnits = CreateUnitStack(leftSideUnitData, SPAWN_LEFT)
    local rightSideUnits = CreateUnitStack(rightSideUnitData, SPAWN_RIGHT)

    UpdateStatisticsFrames()

    battleInfoWrapperFrame:animateFadeIn(0.4, function()
        TimerStart(CreateTimer(), 1, false, function()
            battleInfoWrapperFrame:animateFadeOut(0.4)
        end)
    end)
    for _, unit in ipairs(leftSideUnits) do
        IssuePointOrder(unit, "attack", SPAWN_CENTER_DISTANCE, 0)
    end
    for _, unit in ipairs(rightSideUnits) do
        IssuePointOrder(unit, "attack", -SPAWN_CENTER_DISTANCE, 0)
    end

    TimerStart(sideUnitsAttackRecycleTimer, SIDE_UNITS_ATTACK_RECYCLE_TIMER_DURATION, false, IssueSideUnitsAttackRecycle)
    TimerStart(centerCameraTimer, CENTER_CAMERA_DURATION, true, CenterCameraOnGroups)

    CenterCameraOnGroups()
end

sideUnitsAttackRecycleTimer = CreateTimer()
SIDE_UNITS_ATTACK_RECYCLE_TIMER_DURATION = 2

function IssueUnitAttackRandomTarget(whichUnit, unitSide)
    if (GetUnitCurrentOrder(whichUnit) == 0) then
        local targetUnit = GroupPickRandomUnit(sideGroups[unitSide == SPAWN_LEFT and SPAWN_RIGHT or SPAWN_LEFT])
        if targetUnit ~= nil then
            IssuePointOrder(whichUnit, "attack", GetUnitX(targetUnit), GetUnitY(targetUnit))
        end
    end
end

function IssueSideUnitsAttackRecycle()
    for _, spawnSide in ipairs({SPAWN_LEFT, SPAWN_RIGHT}) do
        ForGroup(sideGroups[spawnSide], function()
            local unit = GetEnumUnit()
            IssueUnitAttackRandomTarget(unit, spawnSide)
        end)
    end
    TimerStart(sideUnitsAttackRecycleTimer, SIDE_UNITS_ATTACK_RECYCLE_TIMER_DURATION, false, IssueSideUnitsAttackRecycle)
end

function FormatStatisticsTextFromData(unitData)
    local victoryPercentage = 0
    if unitData.battles > 0 then
        victoryPercentage = unitData.victories / unitData.battles * 100
    end
    return "Всего побеждено: " .. tostring(unitData.total_killed) .. "\nВсего потеряно: " .. tostring(unitData.total_died) .. "\nВсего битв: " .. tostring(unitData.battles) .. "\nВсего побед: " .. tostring(unitData.victories) .. " (" .. string.format("%.2f", victoryPercentage) .. "%)"
end

function UpdateStatisticsFrames()
    local leftSideUnitsData = unitList[leftSideSpawnData.raceIndex].units[leftSideSpawnData.unitIndex]
    local rightSideUnitsData = unitList[rightSideSpawnData.raceIndex].units[rightSideSpawnData.unitIndex]
    sideFrames[SPAWN_LEFT].statistics:setText(FormatStatisticsTextFromData(leftSideUnitsData))
    sideFrames[SPAWN_RIGHT].statistics:setText(FormatStatisticsTextFromData(rightSideUnitsData))
end

function BattleUnitDefeatTrgAction()
    local unit = GetTriggerUnit()
    local loserSide = unitsInBattle[unit]
    if loserSide == nil then return end
    local winnerSide = loserSide == SPAWN_LEFT and SPAWN_RIGHT or SPAWN_LEFT
    GroupRemoveUnit(sideGroups[loserSide], unit)
    local isHelper = sideHelperUnits[unit]
    if UnitAlive(unit) then
        sideHelperUnits[unit] = true
        unitsInBattle[unit] = winnerSide
        GroupAddUnit(sideGroups[winnerSide], unit)
        IssueUnitAttackRandomTarget(unit, winnerSide)
    end
    if isHelper then
        sideHelperUnits[unit] = nil
        unitsInBattle[unit] = nil
        return
    end
    battleUnitsLeft[loserSide] = battleUnitsLeft[loserSide] - 1
    sideFrames[loserSide].text:setText(tostring(battleUnitsLeft[loserSide]))
    local leftSideUnitsData = unitList[leftSideSpawnData.raceIndex].units[leftSideSpawnData.unitIndex]
    local rightSideUnitsData = unitList[rightSideSpawnData.raceIndex].units[rightSideSpawnData.unitIndex]
    local loserUnitsData = loserSide == SPAWN_LEFT and leftSideUnitsData or rightSideUnitsData
    local winnerUnitsData = loserSide == SPAWN_LEFT and rightSideUnitsData or leftSideUnitsData
    loserUnitsData.total_died = loserUnitsData.total_died + 1
    winnerUnitsData.total_killed = winnerUnitsData.total_killed + 1
    if not isWinningFrameAppearing and battleUnitsLeft[loserSide] <= 0 then
        loserUnitsData.battles = loserUnitsData.battles + 1
        winnerUnitsData.battles = winnerUnitsData.battles + 1
        winnerUnitsData.victories = winnerUnitsData.victories + 1
        isWinningFrameAppearing = true
        battleWinnerTextFrame:setText("|cffffcc00ПОБЕДИТЕЛЬ|r\n\n" .. winnerUnitsData.name)
        battleWinnerBackdropFrame.cover:setVisible(true):animateSize(0.75, nil, 0.3, nil, nil, function()
            DelayCallback(2.5, function()
                battleWinnerTextFrame:animateFadeOut(0.75)
                battleWinnerBackdropFrame.cover:animateSize(1.25, nil, 0, nil, nil, function()
                    battleWinnerBackdropFrame.cover:setVisible(false)
                    DelayCallback(1, function()
                        table.insert(loserUnitsData.history, {
                            enemy = winnerUnitsData,
                            units_left = battleUnitsLeft[winnerSide],
                            is_winner = false
                        })
                        table.insert(winnerUnitsData.history, {
                            enemy = loserUnitsData,
                            units_left = battleUnitsLeft[winnerSide],
                            is_winner = true
                        })
                        isWinningFrameAppearing = false
                        PrepareNewBattle()
                    end)
                end)
            end)
        end)
        DelayCallback(0.35, function()
            battleWinnerTextFrame:animateFadeIn(0.4)
        end)
    end
    if not isHelper then
        unitsInBattle[unit] = nil
    end
    UpdateStatisticsFrames()
    --debugPrint("Left on side " .. unitSide .. ": " .. battleUnitsLeft[unitSide])
end

function BattleUnitSummonHelperAction()
    local summonerUnit = GetSummoningUnit()
    local unitSide = unitsInBattle[summonerUnit]
    if unitSide == nil then return end
    local summonedUnit = GetTriggerUnit()
    if summonedUnit == nil then return end
    sideHelperUnits[summonedUnit] = true
    unitsInBattle[summonedUnit] = unitSide
    GroupAddUnit(sideGroups[unitSide], summonedUnit)
    DelayCallback(1, function()
        IssueUnitAttackRandomTarget(summonedUnit, unitSide)
    end)
end

function BattleUnitTemporaryDisableSpiritFormAction()
    local unit = GetTriggerUnit()
    local spellId = GetSpellAbilityId()
    if GetUnitCurrentOrder(unit) == OrderId("uncorporealform") then
        DelayCallback(10, function()
            IssueImmediateOrder(unit, "corporealform")
            BlzUnitDisableAbility(unit, spellId, true, false)
            DelayCallback(15, function()
                if UnitAlive(unit) then
                    BlzUnitDisableAbility(unit, spellId, false, false)
                end
            end)
        end)
    end
end

centerCameraTimer = CreateTimer()
panningCamera = CreateCameraSetup()
CENTER_CAMERA_DURATION = 0.5
PANNING_CAMERA_FOV_X = 70.0
PANNING_CAMERA_ANGLE_OF_ATTACK = 304.0

function CenterCameraOnGroups()
    local minX = 0
    local maxX = 0
    local minY = 0
    local maxY = 0
    --local totalX = 0.0
    --local totalY = 0.0
    --local totalUnits = 0
    for _, sideGroup in ipairs(sideGroups) do
        ForGroup(sideGroup, function()
            local unit = GetEnumUnit()
            minX = math.min(minX, GetUnitX(unit))
            maxX = math.max(maxX, GetUnitX(unit))
            minY = math.min(minY, GetUnitY(unit))
            maxY = math.max(maxY, GetUnitY(unit))
            --totalX = totalX + GetUnitX(unit)
            --totalY = totalY + GetUnitY(unit)
            --totalUnits = totalUnits + 1
        end)
    end
    --totalUnits = math.max(1, totalUnits)
    --local centerX = totalX / totalUnits
    --local centerY = totalY / totalUnits
    local centerX = (maxX + minX) / 2
    local centerY = (maxY + minY) / 2
    local width = maxX - minX
    local height = (maxY - minY) * math.cos(math.rad(PANNING_CAMERA_ANGLE_OF_ATTACK - 270))
    local fovY = math.deg(2 * math.atan(math.tan(math.rad(PANNING_CAMERA_FOV_X / 2)) / math.sqrt((BlzGetLocalClientWidth() / BlzGetLocalClientHeight()) ^ 2 + 1)))
    local distanceWidth = width / (2 * math.tan(math.rad(PANNING_CAMERA_FOV_X / 2)))
    local distanceHeight = height / (2 * math.tan(math.rad(fovY / 2)))
    local distance = math.max(distanceWidth, distanceHeight, 1000) * 1.15
    CameraSetupSetField(panningCamera, CAMERA_FIELD_TARGET_DISTANCE, distance, 0.0)
    CameraSetupSetDestPosition(panningCamera, centerX, centerY, 0.0)
    CameraSetupApplyForceDuration(panningCamera, true, CENTER_CAMERA_DURATION)
end

OnInit.map(function()
    FogEnable(false)
    FogMaskEnable(false)
    SetCameraPosition(0, 0)
    SetTimeOfDay(12)
    SuspendTimeOfDay(true)
    SetPlayerAlliance(Player(1), Player(0), ALLIANCE_SHARED_VISION, true)
    SetPlayerAlliance(Player(2), Player(0), ALLIANCE_SHARED_VISION, true)
    --SetPlayerAlliance(Player(1), Player(0), ALLIANCE_SHARED_CONTROL, true)
    --SetPlayerAlliance(Player(2), Player(0), ALLIANCE_SHARED_CONTROL, true)

    sideFrames = {
        [SPAWN_LEFT] = {
            icon = leftSideIconFrame,
            text = leftSideTextFrame,
            statistics = leftSideStatisticsTextFrame,
        },
        [SPAWN_RIGHT] = {
            icon = rightSideIconFrame,
            text = rightSideTextFrame,
            statistics = rightSideStatisticsTextFrame,
        }
    }
    battleSideFrames = {
        [SPAWN_LEFT] = battleInfoLeftSideTitleFrame,
        [SPAWN_RIGHT] = battleInfoRightSideTitleFrame
    }

    CameraSetupSetField(panningCamera, CAMERA_FIELD_ZOFFSET, 0.0, 0.0)
    CameraSetupSetField(panningCamera, CAMERA_FIELD_ROTATION, 90.0, 0.0)
    CameraSetupSetField(panningCamera, CAMERA_FIELD_ANGLE_OF_ATTACK, PANNING_CAMERA_ANGLE_OF_ATTACK, 0.0)
    CameraSetupSetField(panningCamera, CAMERA_FIELD_TARGET_DISTANCE, 1650.0, 0.0)
    CameraSetupSetField(panningCamera, CAMERA_FIELD_ROLL, 0.0, 0.0)
    CameraSetupSetField(panningCamera, CAMERA_FIELD_FIELD_OF_VIEW, PANNING_CAMERA_FOV_X, 0.0)
    CameraSetupSetField(panningCamera, CAMERA_FIELD_FARZ, 5000.0, 0.0)
    CameraSetupSetField(panningCamera, CAMERA_FIELD_NEARZ, 16.0, 0.0)
    CameraSetupSetField(panningCamera, CAMERA_FIELD_LOCAL_PITCH, 0.0, 0.0)
    CameraSetupSetField(panningCamera, CAMERA_FIELD_LOCAL_YAW, 0.0, 0.0)
    CameraSetupSetField(panningCamera, CAMERA_FIELD_LOCAL_ROLL, 0.0, 0.0)
    CameraSetupSetDestPosition(panningCamera, 0, 0, 0.0)

    --local unit = CreateUnit(Player(0), FourCC('hsor'), 0, 0, 0)
    --debugPrintAny(BlzGetUnitWeaponIntegerField(unit, UNIT_WEAPON_IF_ATTACK_ATTACK_TYPE, 0))
    --SetHeroLevel(unit, 10, false)
    --for _, ability in ipairs(heroAbilities['Hamg']) do
    --    repeat
    --        local prevLevel = GetUnitAbilityLevel(unit, FourCC(ability))
    --        SelectHeroSkill(unit, FourCC(ability))
    --    until prevLevel == GetUnitAbilityLevel(unit, FourCC(ability))
    --end

    battleUnitDefeatTrg = CreateTrigger()
    TriggerAddAction(battleUnitDefeatTrg, BattleUnitDefeatTrgAction)

    battleUnitHelperSummonTrg = CreateTrigger()
    TriggerRegisterPlayerUnitEvent(battleUnitHelperSummonTrg, Player(1), EVENT_PLAYER_UNIT_SUMMON)
    TriggerRegisterPlayerUnitEvent(battleUnitHelperSummonTrg, Player(2), EVENT_PLAYER_UNIT_SUMMON)
    TriggerAddAction(battleUnitHelperSummonTrg, BattleUnitSummonHelperAction)

    battleUnitTemporaryDisableSpiritFormTrg = CreateTrigger()
    TriggerRegisterPlayerUnitEvent(battleUnitTemporaryDisableSpiritFormTrg, Player(1), EVENT_PLAYER_UNIT_SPELL_EFFECT)
    TriggerRegisterPlayerUnitEvent(battleUnitTemporaryDisableSpiritFormTrg, Player(2), EVENT_PLAYER_UNIT_SPELL_EFFECT)
    TriggerAddAction(battleUnitTemporaryDisableSpiritFormTrg, BattleUnitTemporaryDisableSpiritFormAction)
end)

OnInit.final(function()
    for _, leftRaceUnits in ipairs(unitList) do
        for _, leftUnitData in ipairs(leftRaceUnits.units) do
            for _, rightRaceUnits in ipairs(unitList) do
                for _, rightUnitData in ipairs(rightRaceUnits.units) do
                    if leftUnitData ~= rightUnitData then
                        local pushEntry = true
                        for _, history in ipairs(leftUnitData.history) do
                            if rightUnitData == history.enemy then
                                pushEntry = false
                                break
                            end
                        end
                        if pushEntry then
                            local isWinner = math.random(1, 2) == 1
                            local unitsLeft = math.random(1, 100)
                            leftUnitData.battles = leftUnitData.battles + 1
                            rightUnitData.battles = rightUnitData.battles + 1
                            leftUnitData.victories = leftUnitData.victories + (isWinner and 1 or 0)
                            rightUnitData.victories = rightUnitData.victories + (not isWinner and 1 or 0)
                            table.insert(leftUnitData.history, {
                                enemy = rightUnitData,
                                units_left = unitsLeft,
                                is_winner = isWinner
                            })
                            table.insert(rightUnitData.history, {
                                enemy = leftUnitData,
                                units_left = unitsLeft,
                                is_winner = not isWinner
                            })
                        end
                    end
                end
            end
        end
    end
    ShowFinalRacesFrame(unitList)
    local flatUnitNotHeroList = {}
    local flatUnitHeroList = {}
    for _, raceUnits in ipairs(unitList) do
        for _, unit in ipairs(raceUnits.units) do
            if unit.is_hero then
                table.insert(flatUnitHeroList, unit)
            else
                table.insert(flatUnitNotHeroList, unit)
            end
        end
    end
    local topUnitHeroList = {table.unpack(flatUnitHeroList)}
    table.sort(topUnitHeroList, function(a, b)
        return a.victories > b.victories
    end)
    topUnitHeroList = {table.unpack(topUnitHeroList, 1, 5)}
    local worstUnitHeroList = {table.unpack(flatUnitHeroList)}
    table.sort(worstUnitHeroList, function(a, b)
        return a.victories < b.victories
    end)
    worstUnitHeroList = {table.unpack(worstUnitHeroList, 1, 5)}
    for _, unit in ipairs(worstUnitHeroList) do
        debugPrint(unit.name)
    end
    --PrepareNewBattle()
end)
--CUSTOM_CODE
function Trig_Untitled_Trigger_001_Conditions()
if (not (IsUnitType(GetTriggerUnit(), UNIT_TYPE_STRUCTURE) == true)) then
return false
end
return true
end

function Trig_Untitled_Trigger_001_Actions()
CameraSetupApplyForPlayer(true, gg_cam_Camera_001, Player(0), 2.00)
SetTimeOfDay(12)
UseTimeOfDayBJ(false)
end

function InitTrig_Untitled_Trigger_001()
gg_trg_Untitled_Trigger_001 = CreateTrigger()
TriggerAddCondition(gg_trg_Untitled_Trigger_001, Condition(Trig_Untitled_Trigger_001_Conditions))
TriggerAddAction(gg_trg_Untitled_Trigger_001, Trig_Untitled_Trigger_001_Actions)
end

function InitCustomTriggers()
InitTrig_Untitled_Trigger_001()
end

function InitCustomPlayerSlots()
SetPlayerStartLocation(Player(0), 0)
ForcePlayerStartLocation(Player(0), 0)
SetPlayerColor(Player(0), ConvertPlayerColor(0))
SetPlayerRacePreference(Player(0), RACE_PREF_HUMAN)
SetPlayerRaceSelectable(Player(0), false)
SetPlayerController(Player(0), MAP_CONTROL_USER)
SetPlayerStartLocation(Player(1), 1)
ForcePlayerStartLocation(Player(1), 1)
SetPlayerColor(Player(1), ConvertPlayerColor(1))
SetPlayerRacePreference(Player(1), RACE_PREF_RANDOM)
SetPlayerRaceSelectable(Player(1), true)
SetPlayerController(Player(1), MAP_CONTROL_COMPUTER)
SetPlayerStartLocation(Player(2), 2)
ForcePlayerStartLocation(Player(2), 2)
SetPlayerColor(Player(2), ConvertPlayerColor(2))
SetPlayerRacePreference(Player(2), RACE_PREF_RANDOM)
SetPlayerRaceSelectable(Player(2), true)
SetPlayerController(Player(2), MAP_CONTROL_COMPUTER)
end

function InitCustomTeams()
SetPlayerTeam(Player(0), 0)
SetPlayerTeam(Player(1), 1)
SetPlayerTeam(Player(2), 1)
end

function InitAllyPriorities()
SetStartLocPrioCount(1, 1)
SetEnemyStartLocPrioCount(1, 2)
SetEnemyStartLocPrio(1, 0, 2, MAP_LOC_PRIO_LOW)
SetEnemyStartLocPrioCount(2, 2)
SetEnemyStartLocPrio(2, 0, 1, MAP_LOC_PRIO_LOW)
end

function main()
SetCameraBounds(-3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), -3584.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM), 3328.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), -3328.0 + GetCameraMargin(CAMERA_MARGIN_LEFT), 3072.0 - GetCameraMargin(CAMERA_MARGIN_TOP), 3328.0 - GetCameraMargin(CAMERA_MARGIN_RIGHT), -3584.0 + GetCameraMargin(CAMERA_MARGIN_BOTTOM))
SetDayNightModels("Environment\\DNC\\DNCLordaeron\\DNCLordaeronTerrain\\DNCLordaeronTerrain.mdl", "Environment\\DNC\\DNCLordaeron\\DNCLordaeronUnit\\DNCLordaeronUnit.mdl")
NewSoundEnvironment("Default")
SetAmbientDaySound("LordaeronSummerDay")
SetAmbientNightSound("LordaeronSummerNight")
SetMapMusic("Music", true, 0)
CreateCameras()
InitBlizzard()
InitGlobals()
InitCustomTriggers()
end

function config()
SetMapName("TRIGSTR_003")
SetMapDescription("")
SetPlayers(3)
SetTeams(3)
SetGamePlacement(MAP_PLACEMENT_USE_MAP_SETTINGS)
DefineStartLocation(0, -832.0, -1216.0)
DefineStartLocation(1, 1792.0, -960.0)
DefineStartLocation(2, -2048.0, -1216.0)
InitCustomPlayerSlots()
InitCustomTeams()
InitAllyPriorities()
end

