sub main()
  opCount = 1000000

  startTime = CreateObject("roDateTime")
  for i = 0 to opCount step 1
    isInvalidArrayCheck([notRealVar])
  end for
  endTime = CreateObject("roDateTime")
  print "array:      " + getOpsPerSec(startTime, endTime, opCount)

  startTime = CreateObject("roDateTime")
  for i = 0 to opCount step 1
    isInvalidTypeCheck(notRealVar)
  end for
  endTime = CreateObject("roDateTime")
  print "type check: " + getOpsPerSec(startTime, endTime, opCount)

  startTime = CreateObject("roDateTime")
  for i = 0 to opCount step 1
    isInvalidJustInvalid(invalid)
  end for
  endTime = CreateObject("roDateTime")
  print "just invalid: " + getOpsPerSec(startTime, endTime, opCount)
end sub

function isInvalidTypeCheck(thing)
  return type(thing) <> "<uninitialized>" and thing <> invalid
end function

function isInvalidArrayCheck(thing)
  return thing[0] <> invalid
end function

function isInvalidJustInvalid(thing)
  return thing <> invalid
end function

function getOpsPerSec(startDate, endDate, ops)
  startMs = getMilliseconds(startDate)
  endMs = getMilliseconds(endDate)
  seconds = (endMs - startMs) / 1000
  opsPerSec = ops / seconds
  return numberToString(opsPerSec) + " ops/sec"
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