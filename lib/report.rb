require 'report_summary'

class Report
  def initialize
    @nodes = {}
  end

  def [](key)
    @nodes[key]
  end

  def []=(key, json)
    if key.is_a?(Integer) and json.is_a?(Hash) then
      @nodes[key] = json
    end
  end

  def baddies=(baddies)
    @baddies = baddies
  end

  def baddies
    @baddies ||= []
  end

  def not_loaded
    @nodes.collect { |k,v| v['loading_status'] }.find_all do |n|
      !n['loaded']
    end
  end

  def not_forging
    @nodes.collect { |k,v| v['mining_info'] }.find_all do |n|
      !n['forging']
    end
  end

  def total_nodes
    @nodes.size
  end

  def total_configured
    CryptiKit.config['servers'].size
  end

  def total_checked
    "#{total_nodes} / #{total_configured} Configured"
  end

  def total_forged
    total_balance('totalForged', 'mining_info')
  end

  def total_balance(type = 'balance', parent = 'account_balance')
    balance = 0.0
    @nodes.collect { |k,v| v[parent.to_s] }.collect do |n|
      balance += n[type.to_s].to_f
    end
    balance.to_xcr
  end

  def total_unconfirmed
    total_balance('unconfirmedBalance')
  end

  def total_effective
    total_balance('effectiveBalance')
  end

  def lowest_effective
    @nodes.collect do |k,v|
      v['account_balance'] if v['account_balance']['effectiveBalance']
    end.compact.min do |a,b|
      a['effectiveBalance'] <=> b['effectiveBalance']
    end
  end

  def highest_effective
    @nodes.collect do |k,v|
      v['account_balance'] if v['account_balance']['effectiveBalance']
    end.compact.max do |a,b|
      a['effectiveBalance'] <=> b['effectiveBalance']
    end
  end

  def to_s
    report = String.new
    if @baddies.any? or @nodes.any? then
      @nodes.values.each { |r| report << NodeStatus.new(r).to_s if r.any? }
      report << ReportSummary.new(self).to_s
    end
    report
  end
end