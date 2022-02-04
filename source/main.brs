sub main()
    runAllTests()
end sub

sub runAllTests()
    startTime = CreateObject("roDateTime")

    print "Tests starting"
    m.opCount = 1000000
    m.testResults = []

    runTest("add", sub(opCount)
        for i = 0 to opCount
            result = 1 + 1
        end for
    end sub)

    runTest("subtract", sub(opCount)
        for i = 0 to opCount
            result = 1 - 1
        end for
    end sub)

    printResults(m.testResults)

    'really fast tests kill the app before the rest of the results can be printed, so spent just a little time here
    while CreateObject("roDateTime").AsSeconds() - startTime.AsSeconds() < 2
        startTime = startTime
    end while
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