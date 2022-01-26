#
# This service is used to serialize domain instances
#
class DomainSerializer
  def initialize(record, extra: {})
    @record = record
    @page = extra[:page]
    @per_page = extra[:per_page]
  end

  def call
    records = @record.is_a?(Domain) ? [@record] : @record
    prepared_records = prepare_records(records)

    {
      data: prepared_records,
      page: @page,
      per_page: @per_page
    }
  end

  private

  def prepare_records(records)
    records.map do |domain|
      {
        name: domain.name,
        url: domain.url,
        tags: domain.tags
      }
    end
  end
end
