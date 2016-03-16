{ BufferedProcess } = require 'atom'

module.exports =
class LookProvider
  type: 'Look'
  label: 'look'
  selector: '*'
  inclusionPriority: 0
  excludeLowerPriority: false

  wordRegex: /[a-zA-Z][\-a-zA-Z]*$/

  constructor: ->
    atom.config.observe('autocomplete-look.maxSuggestions', (@maxSuggestions) =>)
    atom.config.observe('autocomplete-look.minCandidateLength', (@minCandidateLength) =>)

  getSuggestions: ({ editor, bufferPosition }) ->
    prefix = @getPrefix(editor, bufferPosition)
    return [] unless prefix.length >= @minCandidateLength

    @executeLookCommand(prefix).then((out) =>
      out.split("\n", @maxSuggestions).map((el) => @buildSuggestion(prefix, el))
    ).catch(-> return [])

  getPrefix: (editor, bufferPosition) ->
    line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
    line.match(@wordRegex)?[0] or ''

  executeLookCommand: (keyword) ->
    new Promise (resolve, reject) ->
      options =
        command: 'look'
        args: [keyword]
        stdout: resolve
        exit: (code) ->
          reject() if code != 0

      new BufferedProcess(options).
        onWillThrowError(-> reject())

  buildSuggestion: (prefix, word) ->
    text: word
    type: @type
    rightLabel: @label
    replacementPrefix: prefix
