class ClientAccount
  # -- psql -d letting_development -f show.sql
  # TODO: remove HARDCODED mar/se months: d1.month = 3 and d2.month = 9
  #
  def self.payments(client_id: 1, start_date: '2014-01-01', end_date: '2015-01-01')
    query = <<-SQL
      SELECT a.id, a.property_id as property_id, sum(py.amount) * -1 as amount
      FROM properties as p
      INNER JOIN addresses as ad ON ad.addressable_id = p.id AND ad.addressable_type = 'Property'
      INNER JOIN accounts as a ON a.property_id = p.id
      INNER JOIN payments as py ON py.account_id = a.id
      INNER JOIN charges as ch ON ch.account_id = a.id
      INNER JOIN cycles as c ON ch.cycle_id = c.id
      INNER JOIN due_ons as d1 ON c.id = d1.cycle_Id
      INNER JOIN due_ons as d2 ON c.id = d1.cycle_Id
      WHERE p.human_ref < 6000 AND
            d1.cycle_id = d2.cycle_id AND
            DUE_ONS_COUNT = 2 AND
            d1.month = 3 AND d2.month = 9 AND
            p.client_id = ? AND
            py.booked_on BETWEEN ? AND ?
      GROUP BY a.id, p.id, p.human_ref
      ORDER BY p.human_ref
    SQL
    Account.find_by_sql [query, client_id, start_date, end_date]
  end
end