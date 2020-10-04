class RenderErrorJson
  def createError(props)
    error_base ={
      status:'ERROR',
      api_version: props[:api_version],
      error_code: props[:code]
    }
    case props[:code]
      when 'AE_0001'
        error_base[:mes] = 'アクセス権限がありません。ログインしてください'
      when 'AE_0002'
        error_base[:mes] = 'カレンダーへのアクセス権限がありません。'
      when 'AE_0010'
        error_base[:mes] = 'カレンダーをうまく作成できませんでした'
      when 'AE_0011'
        error_base[:mes] = 'カレンダーをうまく変更できませんでした'
      when 'AE_0012'
        error_base[:mes] = 'カレンダーをうまく削除できませんでした'
      when 'AE_0013'
        error_base[:mes] = 'カレンダーをうまくコピーできませんでした'
    end
    return JSON.pretty_generate(error_base)
  end
  
end
