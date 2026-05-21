org = Organization.find("YOUR_ORGANIZATION_ID")
‌
tickets = org.tickets.where(
:member_ids.in => [nil, []]
)
‌
puts "Total tickets found: #{tickets.count}"
‌
success_count = 0
failure_count = 0
skipped_count = 0
‌
tickets.no_timeout.each do |ticket|
begin
next if ticket.party_id.blank?
‌
party_mapping = PartyMapping.where(
organization_id: org.id,
party_id: ticket.party_id
).first
‌
if party_mapping.present? && party_mapping.member_ids.present?
member_ids = party_mapping.member_ids.compact.uniq
‌
ticket.set(member_ids: member_ids)
‌
success_count += 1
‌
puts "✅ Updated Ticket UID: #{ticket.uid} with #{member_ids.count} member_ids"
else
skipped_count += 1
‌
puts "⚠️ Skipped Ticket UID: #{ticket.uid} - PartyMapping member_ids empty"
end
‌
rescue => e
failure_count += 1
‌
puts "❌ Failed Ticket UID: #{ticket.uid} - #{e.message}"
end
end
‌
puts "======================================"
puts "Script Execution Completed"
puts "======================================"
puts "Total Tickets Checked : #{tickets.count}"
puts "Successfully Updated : #{success_count}"
puts "Skipped Tickets : #{skipped_count}"
puts "Failed Tickets : #{failure_count}"
puts "======================================"