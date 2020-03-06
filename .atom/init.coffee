atom.commands.add 'atom-text-editor',
  'custom:insert-foo': ->
    atom.workspace.getActiveTextEditor()?.insertText('```')
