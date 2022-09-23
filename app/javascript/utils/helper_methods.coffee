import _ from 'lodash'

export mapKeys = (obj, caseName = 'camelCase') =>
  return obj unless typeof(obj) == 'object'
  start = if Array.isArray(obj) then [] else {}
  _.transform(obj, (res, val, key) =>
    v = mapKeys(val, caseName)
    if Array.isArray(obj)
      res.push(v)
    else
      k = if caseName == 'camelCase' then _.camelCase(key) else _.snakeCase(key)
      res[k] = v
  , start)
