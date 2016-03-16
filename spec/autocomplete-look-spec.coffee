describe "AutocompleteLook", ->
  [workspaceElement, provider, editor, completions] = []

  getCompletions = ->
    cursor = editor.getLastCursor()
    start = cursor.getBeginningOfCurrentWordBufferPosition()
    end = cursor.getBufferPosition()
    prefix = editor.getTextInRange([start, end])

    Promise.resolve(
      provider.getSuggestions(
        editor: editor
        bufferPosition: end
        scopeDescriptor: cursor.getScopeDescriptor()
        prefix: prefix
      )
    ).then((res) ->
      completions = res
    )

  beforeEach ->
    waitsForPromise -> atom.packages.activatePackage('autocomplete-look')

    runs ->
      provider = atom.packages.getActivePackage('autocomplete-look').mainModule.getProvider()

    waitsForPromise -> atom.workspace.open()
    runs ->
      editor = atom.workspace.getActiveTextEditor()



  describe 'when the autocomplete-look is enabled', ->
    it 'autocompletes English words with a given prefix', ->
      runs ->
        editor.setText('look')
        editor.moveToBottom()

      waitsForPromise ->
        getCompletions()

      runs ->
        expect(completions.length).toBeGreaterThan(0)
        expect(completions[0].text).toBe('look')


    describe 'but the prefix is not English word', ->
      it 'does not autocompletes words', ->
        runs ->
          editor.setText('hoge')
          editor.moveToBottom()

        waitsForPromise ->
          getCompletions()

        runs ->
          expect(completions.length).toBe(0)
