object WebModule1: TWebModule1
  Actions = <
    item
      Default = True
      MethodType = mtGet
      Name = 'DefaultHandler'
      PathInfo = '/top'
      OnAction = WebModule1DefaultHandlerAction
    end
    item
      MethodType = mtGet
      Name = 'WebActionItem1'
      PathInfo = '/users/*'
      OnAction = WebModule1WebActionItem1Action
    end>
  Height = 230
  Width = 415
  object WebStencilsEngine1: TWebStencilsEngine
    PathTemplates = <>
    RootDirectory = '.\'
    Left = 128
    Top = 40
  end
  object WebStencilsProcessor1: TWebStencilsProcessor
    Engine = WebStencilsEngine1
    InputFileName = '.\templates\index.html'
    Left = 296
    Top = 40
  end
  object FDMemTable1: TFDMemTable
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'Index'
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 128
    Top = 128
    object FDMemTable1Index: TIntegerField
      FieldName = 'Index'
    end
    object FDMemTable1Name: TStringField
      FieldName = 'Name'
      Size = 60
    end
    object FDMemTable1filename: TStringField
      FieldName = 'Url'
      Size = 120
    end
  end
  object WebStencilsProcessor2: TWebStencilsProcessor
    Engine = WebStencilsEngine1
    InputFileName = '.\templates\gphoto.html'
    PathTemplate = '/users/{user}'
    OnValue = WebStencilsProcessor2Value
    Left = 296
    Top = 128
  end
end
