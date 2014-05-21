flatten = (arrays) ->
  res=[]
  ((res.push val) for val in arr )for arr in arrays
  res

removeDuplicates = (array) ->
  if array.length==0
    return []
  res={}
  res[array[key]]=array[key] for key in [0...array.length]
  value for key,value of res
  
hasDuplicates = (array) ->
  if array.length<=1
    return false
  res={}
  for key in [0...array.length]
    if res[array[key]]?
      return true
    else
      res[array[key]]=array[key]
  return false

concatenate = (arrays...) ->
  res=[]
  ((res.push val) for val in arr )for arr in arrays
  res

union = (arrays...) ->
  removeDuplicates concatenate arrays...
  
exclusion = (array,arraytoexclude) ->
  elem for elem in array when not (elem in arraytoexclude)

isIncluded = (array,arrayincluded) ->
  arrayincluded.reduce ((currentValue,incoming)->
    currentValue and (incoming in array)),true

exports.flatten = flatten
exports.removeDuplicates = removeDuplicates
exports.concatenate = concatenate
exports.union = union
exports.hasDuplicates = hasDuplicates
exports.exclusion = exclusion
exports.isIncluded = isIncluded