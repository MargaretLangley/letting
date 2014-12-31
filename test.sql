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
WHERE (ch.charge_type = 'Ground Rent' OR
      ch.charge_type = 'Garage Ground Rent') AND
      pr.human_ref < 6000 AND
      DUE_ONS_COUNT = 2 AND
      du1.month = 3 AND du2.month = 9 AND
      pr.client_id = 1 AND
      py.booked_on BETWEEN '2014-01-01' AND '2015-01-01'
GROUP BY ac.id, pr.id, pr.human_ref
ORDER BY pr.human_ref
