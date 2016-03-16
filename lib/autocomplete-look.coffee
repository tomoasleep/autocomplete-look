LookProvider = require './look-provider'

module.exports = AutocompleteLook =
  activate: ->
  deactivate: ->

  config:
    maxSuggestions:
      type: 'integer'
      default: 15
      minimum: 1
    minCandidateLength:
      type: 'integer'
      default: 3
      minimum: 1

  getProvider: ->
    @provider ?= new LookProvider()

  provide: ->
    @getProvider()
