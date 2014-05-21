'use strict'

DSP = require '../lib/dsp.js'

# ###
# Removes a module from the cache
# ###
# require.uncache = (moduleName) ->
  
#   # Run over the cache looking for the files
#   # loaded by the specified module name
#   require.searchCache moduleName, (mod) ->
#     delete require.cache[mod.id]

#     return

#   return
# ###
# Runs over the cache to search for all the cached
# files
# ###
# require.searchCache = (moduleName, callback) ->
  
#   # Resolve the module identified by the specified name
#   mod = require.resolve(moduleName)
  
#   # Check if the module has been resolved and found within
#   # the cache
#   if mod and ((mod = require.cache[mod]) isnt undefined)
    
#     # Recursively go over the results
#     (run = (mod) ->
      
#       # Go over each of the module's children and
#       # run over it
#       mod.children.forEach (child) ->
#         run child
#         return

      
#       # Call the specified callback providing the
#       # found module
#       callback mod
#       return
#     ) mod
#   return

# require.uncache '../lib/dsp.js'

###
======== A Handy Little Mocha Reference ========
https://github.com/visionmedia/should.js
https://github.com/visionmedia/mocha

Mocha hooks:
  before ()-> # before describe
  after ()-> # after describe
  beforeEach ()-> # before each it
  afterEach ()-> # after each it

Should assertions:
  should.exist('hello')
  should.fail('expected an error!')
  true.should.be.ok
  true.should.be.true
  false.should.be.false

  (()-> arguments)(1,2,3).should.be.arguments
  [1,2,3].should.eql([1,2,3])
  should.strictEqual(undefined, value)
  user.age.should.be.within(5, 50)
  username.should.match(/^\w+$/)

  user.should.be.a('object')
  [].should.be.an.instanceOf(Array)

  user.should.have.property('age', 15)

  user.age.should.be.above(5)
  user.age.should.be.below(100)
  user.pets.should.have.length(5)

  res.should.have.status(200) #res.statusCode should be 200
  res.should.be.json
  res.should.be.html
  res.should.have.header('Content-Length', '123')

  [].should.be.empty
  [1,2,3].should.include(3)
  'foo bar baz'.should.include('foo')
  { name: 'TJ', pet: tobi }.user.should.include({ pet: tobi, name: 'TJ' })
  { foo: 'bar', baz: 'raz' }.should.have.keys('foo', 'bar')

  (()-> throw new Error('failed to baz')).should.throwError(/^fail.+/)

  user.should.have.property('pets').with.lengthOf(4)
  user.should.be.a('object').and.have.property('name', 'tj')
###

describe 'DSP', ()->
  describe 'sum', ()->
    it 'value', ()->
      DSP.sum([0,1,2,3,4],[1,1,1,1,1]).should.eql([1,2,3,4,5])
  describe 'mean', ()->
    it 'value', ()->
      DSP.mean([1,1,1,3,3,3]).should.eql(2)
  describe 'sum', ()->
    it 'value', ()->
      DSP.sum([1,2,3,4,5],[6,7,8,9,10]).should.eql([7,9,11,13,15])
  describe 'difference', ()->
    it 'value', ()->
      DSP.difference([1,2,3,4,5],[6,7,8,9,10]).should.eql([-5,-5,-5,-5,-5])
  describe 'max', ()->
    it 'value', ()->
      DSP.difference([1,2,3,4,5],[6,7,8,9,10]).should.eql([-5,-5,-5,-5,-5])
  describe 'interpolation', ()->
    it 'value short', ()->
      DSP.strokeAggregationToTimeData([0,1,0],[0,2,4],5)
        .should.eql([0,0.5,1,0.5,0])
    it 'value long', ()->
      DSP.strokeAggregationToTimeData([0,1,-1],[0,4,8],9)
        .should.eql([0,0.15625,0.5,0.84375,1,0.6875,0,-0.6875,-1])
  describe 'resize', ()->
    it 'length', ()->
      DSP.resize([1,2,3,4,5],10).length.should.eql(10)
    it 'mean', ()->
      DSP.mean(DSP.resize([1,2,3,4,5],10)).should.eql(3)
    it 'value', ()->
      DSP.resize([1,1,1,0,0,0,1,1,1],3).should.eql([1,0,1])
  describe 'resize monotonic', ()->
    it 'length', ()->
      DSP.resizeMonotonic([1,2,3,4,5],10).length.should.eql(10)
    it 'mean', ()->
      DSP.mean(DSP.resizeMonotonic([1,2,3,4,5],10)).should.eql(3)
    it 'value', ()->
      DSP.resizeMonotonic([1,1,1,0,0,0,1,1,1],3).should.eql([1,0,1])

