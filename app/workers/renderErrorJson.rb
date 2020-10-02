class RenderJson
  def createError(props)
    case props[:code]
      when 'AE_0001'
        json = JSON.pretty_generate({
          status:'ERROR',
          api_version: props[:api_version],
          error_code: props[:code],
          mes:'アクセス権限がありません。ログインしてください'
        })
    end
    return json
  end
  
end
