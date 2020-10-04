class RenderErrorJson
  def createError(props)
    case props[:code]
      when 'AE_0001'
        json = JSON.pretty_generate({
          status:'ERROR',
          api_version: props[:api_version],
          error_code: props[:code],
          mes:'アクセス権限がありません。ログインしてください'
        })
      when 'AE_0002'
        json = JSON.pretty_generate({
          status:'ERROR',
          api_version: props[:api_version],
          error_code: props[:code],
          mes:'カレンダーへのアクセス権限がありません。'
        })
      when 'AE_0010'
        json = JSON.pretty_generate({
          status:'ERROR',
          api_version: props[:api_version],
          error_code: props[:code],
          mes:'カレンダーをうまく作成できませんでした'
        })
      when 'AE_0011'
        json = JSON.pretty_generate({
          status:'ERROR',
          api_version: props[:api_version],
          error_code: props[:code],
          mes:'カレンダーをうまく変更できませんでした'
        })
      when 'AE_0011'
        json = JSON.pretty_generate({
          status:'ERROR',
          api_version: props[:api_version],
          error_code: props[:code],
          mes:'カレンダーをうまく削除できませんでした'
        })
    end
    return json
  end
  
end
