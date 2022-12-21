-- return LeadID / CampaignID combo that occurs more than once
SELECT leadID
FROM Leads l
WHERE EXISTS
			(SELECT CampaignID FROM Campaigns c WHERE c.campaignID = l.leadID AND c.campaignID <> l.leadID);


-- Return CampaignMembers table, keep first LeadID / CampapignID combination 
SELECT DISTINCT l.leadID, cm.campaignID
FROM CampaignMembers cm
LEFT JOIN Leads l
			ON cm.leadID = l.leadID
ORDER BY cm.campaignmembersignup desc;


--Return Campaign Names that have "no" under attended, exclude campaigns yet to start. Output only list of CampaignIDs
SELECT c.campaignID
FROM campaigns c
JOIN campaignmembers cm USING (campaignID)
WHERE c.campaignstartdate <= '2022-12-05'
		AND cm.campaignmemberstatus NOT IN "attended"
ORDER BY c.campaignID;


--Each campaign type with TOP 3 lead names that have most attendances 
SELECT c.campaigntype, 
l.leadname, 
row_number() OVER (PARTITION BY c.campaigntype ORDER BY l.leadname desc) as rn 
FROM campaigns c
JOIN campaignmembers cm USING (campaignID)
JOIN leads l USING (leadID)
ORDER BY c.campaigntype 
WHERE rn <= 3
		AND cm.campaignmemberstatus = "Attended";
		
--Alternate query
SELECT c.campaign type, l.leadname
FROM campaigns c
JOIN campaignmembers cm 
		ON c.campaignID = cm.campaignID
JOIN leads l 
		ON cm.leadID = l.leadID
GROUP BY c.campaigntype, COUNT(l.leadname) desc 
ORDER BY c.campaigntype
HAVING cm.campaignmemberstatus = "Attended"
LIMIT 3;
