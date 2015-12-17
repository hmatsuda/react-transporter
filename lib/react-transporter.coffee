{CompositeDisposable} = require 'atom'
glob = require 'glob'
path = require 'path'

module.exports =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'react-transporter:open-jsx': => @openJSX()

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->

  openJSX: ->
    editor = atom.workspace.getActiveTextEditor()
    cursor = editor.getCursors()[0]
    name = editor.getTextInBufferRange(cursor.getCurrentWordBufferRange())
    if name.length > 0
      for projectPath in atom.project.getPaths()
        filePattern = path.join(projectPath, 'app', 'assets', 'javascripts', '**', "#{name}.js.jsx")
        glob filePattern, {}, (error, files) ->
          for file in files
            atom.workspace.open(file)
          
