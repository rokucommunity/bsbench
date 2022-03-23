sub main()
    runAllTests()
end sub

sub runAllTests()

    print "Tests starting"
    m.opCount = 1000000
    m.testResults = []

    optionalChaining()
    'functionAssignment()
    'hexVsInt()
    'stringCopyVsIntCopy()
    'inStringVsLoops()
    'functionInjection()
    'arrowFunctionWrapper()

    printResults(m.testResults)

    startTime = CreateObject("roDateTime")
    'the print buffer isn't flushed when the app dies, so spin till it flushes
    print " "
    while CreateObject("roDateTime").AsSeconds() - startTime.AsSeconds() < 1
    end while
end sub

sub arrowFunctionWrapper()
    runTest("guard closure", sub(opCount)
        closure = {
            func: sub() : end sub
        }
        for i = 0 to opCount
            callClosureOrFunc(closure)
        end for
    end sub)

    runTest("guard func", sub(opCount)
        for i = 0 to opCount
            callClosureOrFunc(noop)
        end for
    end sub)


    runTest("pure func", sub(opCount)
        for i = 0 to opCount
            noop()
        end for
    end sub)

    runTest("pure closure", sub(opCount)
        closure = {
            func: sub() : end sub
        }
        for i = 0 to opCount
            closure.func()
        end for
    end sub)
end sub

sub callClosureOrFunc(func)
    if type(func) = "Function"
        func()
    else
        func.func()
    end if
end sub

sub functionInjection()
    runTest("no params", sub(opCount)
        for i = 0 to opCount step 1
            noop()
        end for
    end sub)

    runTest("default params", sub(opCount)
        for i = 0 to opCount step 1
            autoInject()
        end for
    end sub)
end sub

sub autoInject(a = functionInjection, b = functionInjection, c = functionInjection, d = functionInjection, e = functionInjection, f = functionInjection, g = functionInjection)
end sub

sub inStringVsLoops()
    runTest("instring hit beginning", sub(opCount)
        data = "|billing_zip_code|billing_zip_codehome_zip_code|current_zip_code|tms_id|airing_id|program_type|title|channel_id|channel|callsign|network_owner|duration|publish_date|sunset_date|in_home|asset_id|is_live|series_id|series_title|episode_title|season_number|episode_number|format|air_date|sport_ids|sport_names|league_ids|league_names|team_ids|team_names|genres|playback_type|is_premiere|reporting_entity|channel_type|"
        value = 0
        for i = 0 to opCount step 1
            Instr(0, data, "|billing_zip_code|")
        end for
    end sub)

    runTest("instring hit end", sub(opCount)
        data = "|billing_zip_code|home_zip_code|current_zip_code|tms_id|airing_id|program_type|title|channel_id|channel|callsign|network_owner|duration|publish_date|sunset_date|in_home|asset_id|is_live|series_id|series_title|episode_title|season_number|episode_number|format|air_date|sport_ids|sport_names|league_ids|league_names|team_ids|team_names|genres|playback_type|is_premiere|reporting_entity|channel_type|"
        value = 0
        for i = 0 to opCount step 1
            Instr(0, data, "|channel_type|")
        end for
    end sub)

    runTest("instring miss", sub(opCount)
        data = "|billing_zip_code|home_zip_code|current_zip_code|tms_id|airing_id|program_type|title|channel_id|channel|callsign|network_owner|duration|publish_date|sunset_date|in_home|asset_id|is_live|series_id|series_title|episode_title|season_number|episode_number|format|air_date|sport_ids|sport_names|league_ids|league_names|team_ids|team_names|genres|playback_type|is_premiere|reporting_entity|channel_type|"
        value = 0
        for i = 0 to opCount step 1
            Instr(0, data, "|billing_zip_code_nope|")
        end for
    end sub)

    runTest("in array hit beginning", sub(opCount)
        data = ["billing_zip_code", "home_zip_code", "current_zip_code", "tms_id", "airing_id", "program_type", "title", "channel_id", "channel", "callsign", "network_owner", "duration", "publish_date", "sunset_date", "in_home", "asset_id", "is_live", "series_id", "series_title", "episode_title", "season_number", "episode_number", "format", "air_date", "sport_ids", "sport_names", "league_ids", "league_names", "team_ids", "team_names", "genres", "playback_type", "is_premiere", "reporting_entity", "channel_type"]
        for i = 0 to opCount step 1
            for each item in data
                if item = "billing_zip_code"
                    exit for
                end if
            end for
        end for
    end sub)

    runTest("in array hit end", sub(opCount)
        data = ["billing_zip_code", "home_zip_code", "current_zip_code", "tms_id", "airing_id", "program_type", "title", "channel_id", "channel", "callsign", "network_owner", "duration", "publish_date", "sunset_date", "in_home", "asset_id", "is_live", "series_id", "series_title", "episode_title", "season_number", "episode_number", "format", "air_date", "sport_ids", "sport_names", "league_ids", "league_names", "team_ids", "team_names", "genres", "playback_type", "is_premiere", "reporting_entity", "channel_type"]
        for i = 0 to opCount step 1
            for each item in data
                if item = "channel_type"
                    exit for
                end if
            end for
        end for
    end sub)

    runTest("in array miss", sub(opCount)
        data = ["billing_zip_code", "home_zip_code", "current_zip_code", "tms_id", "airing_id", "program_type", "title", "channel_id", "channel", "callsign", "network_owner", "duration", "publish_date", "sunset_date", "in_home", "asset_id", "is_live", "series_id", "series_title", "episode_title", "season_number", "episode_number", "format", "air_date", "sport_ids", "sport_names", "league_ids", "league_names", "team_ids", "team_names", "genres", "playback_type", "is_premiere", "reporting_entity", "channel_type"]
        for i = 0 to opCount step 1
            for each item in data
                if item = "billing_zip_code_nope"
                    exit for
                end if
            end for
        end for
    end sub)
end sub

sub stringCopyVsIntCopy()
    runTest("int", sub(opCount)
        value = 0
        for i = 0 to opCount step 1
            callWithInt(2000)
        end for
    end sub)

    runTest("string", sub(opCount)
        value = 0
        for i = 0 to opCount step 1
            callWithString("Analytics_SeasonNumber")
        end for
    end sub)

end sub

sub callWithInt(value as integer)

end sub


sub callWithString(value as string)
end sub


sub callWithIntLookUpString(value as integer)

end sub

sub hexVsInt()



    runTest("hex", sub(opCount)
        value = 0
        for i = 0 to opCount step 1
            value = &hFF
        end for
    end sub)

    runTest("int", sub(opCount)
        for i = 0 to opCount step 1
            value = 255
        end for
    end sub)
end sub

sub functionAssignment()
    runTest("per-assignment", sub(opCount)
        for i = 0 to opCount step 1
            obj = {}
            obj.func1 = sub() : end sub
            obj.func2 = sub() : end sub
            obj.func3 = sub() : end sub
            obj.func4 = sub() : end sub
            obj.func5 = sub() : end sub
            obj.func6 = sub() : end sub
            obj.func7 = sub() : end sub
            obj.func8 = sub() : end sub
            obj.func9 = sub() : end sub
            obj.func10 = sub() : end sub
            obj.func11 = sub() : end sub
            obj.func12 = sub() : end sub
            obj.func13 = sub() : end sub
            obj.func14 = sub() : end sub
            obj.func15 = sub() : end sub
            obj.func16 = sub() : end sub
            obj.func17 = sub() : end sub
            obj.func18 = sub() : end sub
            obj.func19 = sub() : end sub
            obj.func20 = sub() : end sub
            obj.func21 = sub() : end sub
            obj.func22 = sub() : end sub
            obj.func23 = sub() : end sub
            obj.func24 = sub() : end sub
            obj.func25 = sub() : end sub
            obj.func26 = sub() : end sub
            obj.func27 = sub() : end sub
            obj.func28 = sub() : end sub
            obj.func29 = sub() : end sub
            obj.func30 = sub() : end sub
            obj.func31 = sub() : end sub
            obj.func32 = sub() : end sub
            obj.func33 = sub() : end sub
            obj.func34 = sub() : end sub
            obj.func35 = sub() : end sub
            obj.func36 = sub() : end sub
            obj.func37 = sub() : end sub
            obj.func38 = sub() : end sub
            obj.func39 = sub() : end sub
            obj.func40 = sub() : end sub
            obj.func41 = sub() : end sub
            obj.func42 = sub() : end sub
            obj.func43 = sub() : end sub
            obj.func44 = sub() : end sub
            obj.func45 = sub() : end sub
            obj.func46 = sub() : end sub
            obj.func47 = sub() : end sub
            obj.func48 = sub() : end sub
            obj.func49 = sub() : end sub
            obj.func50 = sub() : end sub
            obj.func51 = sub() : end sub
            obj.func52 = sub() : end sub
            obj.func53 = sub() : end sub
            obj.func54 = sub() : end sub
            obj.func55 = sub() : end sub
            obj.func56 = sub() : end sub
            obj.func57 = sub() : end sub
            obj.func58 = sub() : end sub
            obj.func59 = sub() : end sub
            obj.func60 = sub() : end sub
            obj.func61 = sub() : end sub
            obj.func62 = sub() : end sub
            obj.func63 = sub() : end sub
            obj.func64 = sub() : end sub
            obj.func65 = sub() : end sub
            obj.func66 = sub() : end sub
            obj.func67 = sub() : end sub
            obj.func68 = sub() : end sub
            obj.func69 = sub() : end sub
            obj.func70 = sub() : end sub
            obj.func71 = sub() : end sub
            obj.func72 = sub() : end sub
            obj.func73 = sub() : end sub
            obj.func74 = sub() : end sub
            obj.func75 = sub() : end sub
            obj.func76 = sub() : end sub
            obj.func77 = sub() : end sub
            obj.func78 = sub() : end sub
            obj.func79 = sub() : end sub
            obj.func80 = sub() : end sub
            obj.func81 = sub() : end sub
            obj.func82 = sub() : end sub
            obj.func83 = sub() : end sub
            obj.func84 = sub() : end sub
            obj.func85 = sub() : end sub
            obj.func86 = sub() : end sub
            obj.func87 = sub() : end sub
            obj.func88 = sub() : end sub
            obj.func89 = sub() : end sub
            obj.func90 = sub() : end sub
            obj.func91 = sub() : end sub
            obj.func92 = sub() : end sub
            obj.func93 = sub() : end sub
            obj.func94 = sub() : end sub
            obj.func95 = sub() : end sub
            obj.func96 = sub() : end sub
            obj.func97 = sub() : end sub
            obj.func98 = sub() : end sub
            obj.func99 = sub() : end sub
            obj.func100 = sub() : end sub
        end for
    end sub)

    runTest("all-at-once", sub(opCount)
        for i = 0 to opCount step 1
            obj = {
                func1: sub() : end sub
                func2: sub() : end sub
                func3: sub() : end sub
                func4: sub() : end sub
                func5: sub() : end sub
                func6: sub() : end sub
                func7: sub() : end sub
                func8: sub() : end sub
                func9: sub() : end sub
                func10: sub() : end sub
                func11: sub() : end sub
                func12: sub() : end sub
                func13: sub() : end sub
                func14: sub() : end sub
                func15: sub() : end sub
                func16: sub() : end sub
                func17: sub() : end sub
                func18: sub() : end sub
                func19: sub() : end sub
                func20: sub() : end sub
                func21: sub() : end sub
                func22: sub() : end sub
                func23: sub() : end sub
                func24: sub() : end sub
                func25: sub() : end sub
                func26: sub() : end sub
                func27: sub() : end sub
                func28: sub() : end sub
                func29: sub() : end sub
                func30: sub() : end sub
                func31: sub() : end sub
                func32: sub() : end sub
                func33: sub() : end sub
                func34: sub() : end sub
                func35: sub() : end sub
                func36: sub() : end sub
                func37: sub() : end sub
                func38: sub() : end sub
                func39: sub() : end sub
                func40: sub() : end sub
                func41: sub() : end sub
                func42: sub() : end sub
                func43: sub() : end sub
                func44: sub() : end sub
                func45: sub() : end sub
                func46: sub() : end sub
                func47: sub() : end sub
                func48: sub() : end sub
                func49: sub() : end sub
                func50: sub() : end sub
                func51: sub() : end sub
                func52: sub() : end sub
                func53: sub() : end sub
                func54: sub() : end sub
                func55: sub() : end sub
                func56: sub() : end sub
                func57: sub() : end sub
                func58: sub() : end sub
                func59: sub() : end sub
                func60: sub() : end sub
                func61: sub() : end sub
                func62: sub() : end sub
                func63: sub() : end sub
                func64: sub() : end sub
                func65: sub() : end sub
                func66: sub() : end sub
                func67: sub() : end sub
                func68: sub() : end sub
                func69: sub() : end sub
                func70: sub() : end sub
                func71: sub() : end sub
                func72: sub() : end sub
                func73: sub() : end sub
                func74: sub() : end sub
                func75: sub() : end sub
                func76: sub() : end sub
                func77: sub() : end sub
                func78: sub() : end sub
                func79: sub() : end sub
                func80: sub() : end sub
                func81: sub() : end sub
                func82: sub() : end sub
                func83: sub() : end sub
                func84: sub() : end sub
                func85: sub() : end sub
                func86: sub() : end sub
                func87: sub() : end sub
                func88: sub() : end sub
                func89: sub() : end sub
                func90: sub() : end sub
                func91: sub() : end sub
                func92: sub() : end sub
                func93: sub() : end sub
                func94: sub() : end sub
                func95: sub() : end sub
                func96: sub() : end sub
                func97: sub() : end sub
                func98: sub() : end sub
                func99: sub() : end sub
                func100: sub() : end sub
            }
        end for
    end sub)
end sub


sub optionalChaining()
    a = {
        b: {
            c: {
                d: {
                    e: "E"
                }
            }
        }
    }

    runTest("optional-chain-hit", sub(opCount, a)
        for i = 0 to opCount step 1
            result = a?.b?.c?.d?.e
        end for
    end sub, a)

    runTest("optional-chain miss end", sub(opCount, a)
        for i = 0 to opCount step 1
            result = a?.b?.c?.d?.Z
        end for
    end sub, a)

    runTest("object-direct hit", sub(opCount, a)
        for i = 0 to opCount step 1
            result = a.b.c.d.e
        end for
    end sub, a)

    runTest("object-check hit", sub(opCount, a)
        for i = 0 to opCount step 1
            if a <> invalid then
                if a.b <> invalid then
                    if a.b.c <> invalid then
                        if a.b.c.d <> invalid then
                            result = a.b.c.d.e
                        end if
                    end if
                end if
            end if
        end for
    end sub, a)

    runTest("object-check direct miss end", sub(opCount, a)
        for i = 0 to opCount step 1
            if a <> invalid then
                if a.b <> invalid then
                    if a.b.c <> invalid then
                        if a.b.c.d <> invalid then
                            result = a.b.c.d.Z
                        end if
                    end if
                end if
            end if
        end for
    end sub, a)

    runTest("object-check loop hit", sub(opCount, a, keys)
        callCount = 0
        for i = 0 to opCount - 1 step 1
            for each key in keys
                if true then
                    callCount++
                else
                    exit for
                end if
            end for
        end for
        print "expected "; opCount * keys.Count(); ", got "; callCount
    end sub, a, ["b", "c", "d", "Z"])

    runTest("object-check loop miss", sub(opCount, a, keys)
        for i = 0 to opCount step 1
            obj = a
            for each key in keys
                nextValue = obj[key]
                if nextValue <> invalid
                    obj = nextValue
                else
                    exit for
                end if
            end for
        end for
    end sub, a, ["b", "c", "d", "Z"])

    runTest("object-check loop tokenize miss", sub(opCount, a, keyText)
        for i = 0 to opCount step 1
            keys = keyText.tokenize(".")
            obj = a
            for each key in keys
                nextValue = obj[key]
                if nextValue <> invalid
                    obj = nextValue
                else
                    exit for
                end if
            end for
        end for
    end sub, a, "b.c.d.Z")
end sub


function getOpsPerSec(startDate, endDate, ops)
    startMs = getMilliseconds(startDate)
    endMs = getMilliseconds(endDate)
    seconds = (endMs - startMs) / 1000
    opsPerSec = ops / seconds
    return opsPerSec
end function

function getMilliseconds(date)
    result = 0
    result += date.GetMinutes() * 60 * 1000
    result += date.GetSeconds() * 1000
    result += date.GetMilliseconds()
    return result
end function

function numberToString(num)
    result = ""
    i = 0
    while num > 1
        loopNum = (num mod 10).ToStr().Trim()
        result = loopNum + result
        num = num / 10
        i++
        if i mod 3 = 0 and num > 1 then
            result = "," + result
        end if
    end while
    result = result + "." + ((num * 10) mod 1).ToStr().Trim() + ((num * 100) mod 1).ToStr().Trim()
    return result
end function

'
' Run a single test.
' @param name - the name of the test
' @param testFn - reference to the test to run
' @param args - an array of parameters to pass as arguments to the test function
'
sub runTest(name as string, testFunc as function, arg1 = invalid, arg2 = invalid, arg3 = invalid, arg4 = invalid)
    opCount = m.opCount
    if arg4 <> invalid
        startTime = CreateObject("roDateTime")
        testFunc(opCount, arg1, arg2, arg3, arg4)
        endTime = CreateObject("roDateTime")
    else if arg3 <> invalid
        startTime = CreateObject("roDateTime")
        testFunc(opCount, arg1, arg2, arg3)
        endTime = CreateObject("roDateTime")
    else if arg2 <> invalid
        startTime = CreateObject("roDateTime")
        testFunc(opCount, arg1, arg2)
        endTime = CreateObject("roDateTime")
    else if arg1 <> invalid
        startTime = CreateObject("roDateTime")
        testFunc(opCount, arg1)
        endTime = CreateObject("roDateTime")
    else
        startTime = CreateObject("roDateTime")
        testFunc(opCount)
        endTime = CreateObject("roDateTime")
    end if
    result = {
        name: name
        opsPerSec: getOpsPerSec(startTime, endTime, opCount)
    }
    print name; " (DONE)"
    m.testResults.push(result)
end sub

function printResults(results)
    print ""
    print "RESULTS:"
    print padRight("", 50, "_")
    print ""
    highestOpsPerSec = results[0].opsPerSec
    lowestOpsPerSec = results[0].opsPerSec
    opsPerSecMaxLen = 0
    nameLengthMaxLen = 0
    for each result in results
        'calculate slowest
        if result.opsPerSec < lowestOpsPerSec
            lowestOpsPerSec = result.opsPerSec
        end if

        'calculate highest ops/sec
        if result.opsPerSec > highestOpsPerSec
            highestOpsPerSec = result.opsPerSec
        end if

        'calculate logest ops/sec string
        opsPerSecTextLength = numberToString(result.opsPerSec).Len()
        if opsPerSecTextLength > opsPerSecMaxLen
            opsPerSecMaxLen = opsPerSecTextLength
        end if

        'calculate longest name
        if result.name.Len() > nameLengthMaxLen
            nameLengthMaxLen = result.name.Len()
        end if

    end for
    for each result in results
        postfix = ""
        if result.opsPerSec = highestOpsPerSec then
            postfix = " (fastest)"
        end if
        if result.opsPerSec = lowestOpsPerSec then
            postfix = " (slowest)"
        end if
        printResult(result, nameLengthMaxLen + 5, opsPerSecMaxLen, postfix)
    end for
end function

'
' Print a single test result
'
sub printResult(result, namePadding = 1, opsPadding = 0, postfix = "")
    print padRight(result.name + ": ", namePadding, "-"); " "; padLeft(numberToString(result.opsPerSec), opsPadding, " "); " ops/sec"; postfix
end sub

function padRight(value as string, padLength = 2 as integer, paddingCharacter = "0" as dynamic) as string
    while value.len() < padLength
        value += paddingCharacter
    end while
    return value
end function

function padLeft(value as string, padLength = 2 as integer, paddingCharacter = "0" as dynamic) as string
    while value.len() < padLength
        value = paddingCharacter + value
    end while
    return value
end function

sub noop()
end sub