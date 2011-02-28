
class ValueBuffer
  constructor: ( @delay, @value ) ->
    @delay ?= 300
  set_value : (new_value) ->
    if @new_value_candidate isnt new_value
      @new_value_candidate = new_value
      clearTimeout @timeout if @timeout?
      @timeout = setTimeout @_set_value2, @delay
  _set_value2 : =>
    if @value isnt @new_value_candidate
      @value = @new_value_candidate
      $(@).trigger 'change'

###
de = new DeferredExecutor
de.add -> foo # not executed
de.add -> bar # not executed
de.initialize() # causes foo() and bar() to execute
de.add -> baz # baz() will execute right away
###
class DeferredExecutor
  constructor: ->
    @funcs = []
  add: (func) =>
    if @initialized
      func()
    else
      @funcs.push func
  initialize: ->
    @initialized = yes
    func() for func in @funcs
    delete @funcs

exports.ValueBuffer = ValueBuffer
exports.DeferredExecutor = DeferredExecutor