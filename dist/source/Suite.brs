function __Suite_builder()
    instance = {}
    instance.new = sub()
        m.benchmarks = []
    end sub
    instance.add = function(name as string, testFunction as function, context = "__invalid" as dynamic)
        m.benchmarks.Push({
            name: name
            testFunction: testFunction
            context: context
        })
    end function
    '
    ' Run the entire suite, with each benchmark running in the order added
    '
    instance.run = sub(runOptions as dynamic)
        for each benchmark in m.benchmarks
            m.runOne(benchmark, runOptions)
        next
        m.printResults()
    end sub
    '
    ' Run a single benchmark
    '
    instance.runOne = function(benchmark as dynamic, runOptions as dynamic)
        RunGarbageCollector()
        print benchmark.name; " (WARMING UP)"
        if benchmark.context = "__invalid"
            benchmark.testFunction(runOptions.iterations)
        else
            benchmark.testFunction(runOptions.iterations, benchmark.context)
        end if
        print benchmark.name; " (RUNNING)"
        'if no context was provided, call the test function without a context
        if benchmark.context = "__invalid"
            startTime = CreateObject("roDateTime")
            benchmark.testFunction(runOptions.iterations)
            endTime = CreateObject("roDateTime")
        else
            startTime = CreateObject("roDateTime")
            benchmark.testFunction(runOptions.iterations, benchmark.context)
            endTime = CreateObject("roDateTime")
        end if
        benchmark.result = {
            opsPerSecond: m.getOpsPerSec(startTime, endTime, runOptions.iterations)
            duration: endTime.GetSeconds() - startTime.GetSeconds()
        }
        print benchmark.name; " (DONE)"
        RunGarbageCollector()
    end function
    instance.finalize = sub()
    end sub
    instance.getOpsPerSec = function(startDate, endDate, ops)
        startMs = m.getMilliseconds(startDate)
        endMs = m.getMilliseconds(endDate)
        seconds = (endMs - startMs) / 1000
        if seconds = 0 then
            seconds = 0.0000001
        end if
        opsPerSec = ops / seconds
        return opsPerSec
    end function
    instance.printResults = function()
        print ""
        print "RESULTS:"
        print m.padRight("", 50, "_")
        print ""
        highestOpsPerSec = m.benchmarks[0].result.opsPerSecond
        lowestOpsPerSec = m.benchmarks[0].result.opsPerSecond
        opsPerSecMaxLen = 0
        nameLengthMaxLen = 0
        for each benchmark in m.benchmarks
            result = benchmark.result
            'calculate slowest
            if result.opsPerSecond < lowestOpsPerSec
                lowestOpsPerSec = result.opsPerSecond
            end if
            'calculate highest ops/sec
            if result.opsPerSecond > highestOpsPerSec
                highestOpsPerSec = result.opsPerSecond
            end if
            'calculate logest ops/sec string
            opsPerSecTextLength = m.numberToString(result.opsPerSecond).Len()
            if opsPerSecTextLength > opsPerSecMaxLen
                opsPerSecMaxLen = opsPerSecTextLength
            end if
            'calculate longest name
            if benchmark.name.Len() > nameLengthMaxLen
                nameLengthMaxLen = benchmark.name.Len()
            end if
        end for
        for each benchmark in m.benchmarks
            result = benchmark.result
            postfix = ""
            if result.opsPerSecond = highestOpsPerSec then
                postfix = " (fastest)"
            end if
            if result.opsPerSecond = lowestOpsPerSec then
                postfix = " (slowest)"
            end if
            m.printResult(result, nameLengthMaxLen + 5, opsPerSecMaxLen, postfix)
        end for
    end function
    instance.getMilliseconds = function(date)
        result = 0
        result += date.GetMinutes() * 60 * 1000
        result += date.GetSeconds() * 1000
        result += date.GetMilliseconds()
        return result
    end function
    '
    ' Print a single test result
    '
    instance.printResult = sub(result, namePadding = 1, opsPadding = 0, postfix = "")
        print m.padRight(result.name + ": ", namePadding, "-"); " "; m.padLeft(m.numberToString(result.opsPerSec), opsPadding, " "); " ops/sec"; postfix
    end sub
    instance.padRight = function(value as string, padLength = 2 as integer, paddingCharacter = "0" as dynamic) as string
        while value.len() < padLength
            value += paddingCharacter
        end while
        return value
    end function
    instance.padLeft = function(value as string, padLength = 2 as integer, paddingCharacter = "0" as dynamic) as string
        while value.len() < padLength
            value = paddingCharacter + value
        end while
        return value
    end function
    instance.numberToString = function(num)
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
    return instance
end function
function Suite()
    instance = __Suite_builder()
    instance.new()
    return instance
end function


