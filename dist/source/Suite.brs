function __Suite_builder()
    instance = {}
    instance.new = sub()
        m.benchmarks = []
    end sub
    instance.add = function(name as string, testFunction as function, context = "__invalid")
        m.benchmarks.push(Benchmark(name, testFunction, context))
    end function
    '
    ' Run the entire suite, with each benchmark running in the order added
    '
    instance.run = sub(runOptions as dynamic)
        for each b in m.benchmarks
            b.run(runOptions)
        next
        m.printResults()
    end sub
    instance.printResults = function()
        print ""
        print "RESULTS:"
        print m.padRight("", 50, "_")
        print ""
        highestOpsPerSec = m.benchmarks[0].result.operationsPerSecond
        lowestOpsPerSec = m.benchmarks[0].result.operationsPerSecond
        opsPerSecMaxLen = 0
        nameLengthMaxLen = 0
        for each b in m.benchmarks
            'calculate slowest
            if b.result.operationsPerSecond < lowestOpsPerSec
                lowestOpsPerSec = result.operationsPerSecond
            end if
            'calculate highest ops/sec
            if result.operationsPerSecond > highestOpsPerSec
                highestOpsPerSec = result.operationsPerSecond
            end if
            'calculate logest ops/sec string
            opsPerSecTextLength = m.numberToString(result.operationsPerSecond).Len()
            if opsPerSecTextLength > opsPerSecMaxLen
                opsPerSecMaxLen = opsPerSecTextLength
            end if
            'calculate longest name
            if b.name.Len() > nameLengthMaxLen
                nameLengthMaxLen = b.name.Len()
            end if
        end for
        for each benchmark in m.benchmarks
            result = b.result
            postfix = ""
            if b.result.operationsPerSecond = highestOpsPerSec then
                postfix = " (fastest)"
            end if
            if b.result.operationsPerSecond = lowestOpsPerSec then
                postfix = " (slowest)"
            end if
            m.printResult(result, nameLengthMaxLen + 5, opsPerSecMaxLen, postfix)
        end for
    end function
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
function __Benchmark_builder()
    instance = {}
    instance.new = sub(name as string, testFunction as function, context as dynamic)
        m.name = invalid
        m.testFunction = invalid
        m.context = invalid
        m.result = invalid
        m.name = name
        m.testFunction = testFunction
        m.context = context
    end sub
    instance.runTestFunction = function(iterations as integer)
    end function
    instance.run = function(runOptions as dynamic)
        RunGarbageCollector()
        testFunction = m.testFunction
        print (bslib_toString(m.name) + ": WARMING UP (" + bslib_toString(runOptions.warmupIterations) + " iterations)")
        if m.context = "__invalid"
            testFunction(runOptions.warmupIterations)
        else
            testFunction(runOptions.warmupIterations, m.context)
        end if
        print (bslib_toString(m.name) + ": RUNNING (" + bslib_toString(runOptions.iterations) + " iterations)")
        if m.context = "__invalid"
            startTime = CreateObject("roDateTime")
            testFunction(runOptions.iterations)
            endTime = CreateObject("roDateTime")
        else
            startTime = CreateObject("roDateTime")
            testFunction(runOptions.iterations, m.context)
            endTime = CreateObject("roDateTime")
        end if
        benchmark.result = {
            startTime: startTime
            endTime: endTime
            iterations: runOptions.iterations
            operationsPerSecond: m.getOperationsPerSecond(startTime, endTime, runOptions.iterations)
        }
        print (bslib_toString(m.name) + ": DONE")
        RunGarbageCollector()
    end function
    instance.getOperationsPerSecond = function(startDate, endDate, ops)
        startMs = m.getMilliseconds(startDate)
        endMs = m.getMilliseconds(endDate)
        seconds = (endMs - startMs) / 1000
        if seconds = 0 then
            seconds = 0.0000001
        end if
        opsPerSec = ops / seconds
        return opsPerSec
    end function
    instance.getMilliseconds = function(date)
        result = 0
        result += date.GetMinutes() * 60 * 1000
        result += date.GetSeconds() * 1000
        result += date.GetMilliseconds()
        return result
    end function
    return instance
end function
function Benchmark(name as string, testFunction as function, context as dynamic)
    instance = __Benchmark_builder()
    instance.new(name, testFunction, context)
    return instance
end function

