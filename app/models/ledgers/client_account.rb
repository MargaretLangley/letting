# ClientAccount
#
# Returns the payments
# rubocop: disable Metrics/MethodLength
#
class ClientAccount
  # -- psql -d letting_development -f show.sql
  # TODO: remove HARDCODED mar/se months: d1.month = 3 and d2.month = 9
  #
  def self.payments client_id: 1,
                    start_date: '2014-01-01',
                    end_date: '2015-01-01'
    query = <<-SQL
      SELECT ac.id, ac.property_id as property_id, sum(py.amount) * -1 as amount
      FROM properties      as pr
      INNER JOIN addresses as ad  ON ad.addressable_id = pr.id AND
                                     ad.addressable_type = 'Property'
      INNER JOIN accounts  as ac  ON ac.property_id = pr.id
      INNER JOIN payments  as py  ON py.account_id = ac.id
      INNER JOIN charges   as ch  ON ch.account_id = ac.id
      INNER JOIN cycles    as cy  ON ch.cycle_id = cy.id
      INNER JOIN due_ons   as du1 ON cy.id = du1.cycle_Id
      INNER JOIN due_ons   as du2 ON cy.id = du1.cycle_Id
      WHERE pr.human_ref < 6000 AND
            DUE_ONS_COUNT = 2 AND
            du1.month = 3 AND du2.month = 9 AND
            pr.client_id = ? AND
            py.booked_on BETWEEN ? AND ?
      GROUP BY ac.id, pr.id, pr.human_ref
      ORDER BY pr.human_ref
    SQL
    Account.find_by_sql [query, client_id, start_date, end_date]
  end
end
