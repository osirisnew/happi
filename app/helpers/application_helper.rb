module ApplicationHelper
  def datetime(time)
    l(time, format: time.today? ? :today : :default)
  end

  def cp(path, exact: false)
    exact ? request.fullpath == path : request.fullpath.start_with?(path)
  end

  def dom_ids(records)
    if records.is_a?(Array)
      records.map { |record| dom_id(record) }.join("_")
    else
      dom_id(records)
    end
  end

  def support_email_address
    "support@happi.team"
  end
end
