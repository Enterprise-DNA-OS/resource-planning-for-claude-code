# Record checks and their limits

Sources checked 9 October 2026. This tool supports internal resource planning. It does not certify compliance, provide employment advice or calculate payroll and leave entitlements.

## External rules

[New Zealand Privacy Act principle 9](https://www.privacy.org.nz/privacy-principles/9/) limits personal-data retention to the continuing lawful purpose. IPP9-review flags a missing purpose, a missing review date or an arrived review date on a person. The operator chooses the review date. There is no universal legal retention period encoded here, and the check never deletes data. Review the purpose and the wider records, including exports and activity, before deciding retention.

[Principle 5](https://www.privacy.org.nz/privacy-principles/5/) requires reasonable safeguards for personal information. All business tables have row-level security enabled, public privileges revoked and caller-permission views. The owner connection and embedded database remain trusted operator tools. Before shared use, add authentication, restricted database roles, protected files and tested backups. Actor names are not authenticated identities, and this check cannot assess the deployment's safeguards. Avoid medical details in time-off notes.

[WorkSafe's fatigue guidance](https://www.worksafe.govt.nz/about-us/news-and-media/keep-fatigue-out-of-the-workplace/) describes work schedules and demands as factors to manage. INTERNAL-capacity flags confirmed allocations above the person's configured availability. That is an internal planning threshold, not a statutory hours limit or a fatigue assessment. Talk to workers and responsible managers about demands the records do not capture.

## Internal policies

INTERNAL-owner flags an active or tentative project without an owner. INTERNAL-stale-request flags an open staffing request after its start date. Attention also flags requests untouched for seven days. These thresholds are internal policy. Candidate matching checks skill, role and daily headroom, not qualifications or a person's agreement.

Mutations record an attributed history. Activity rejects updates and deletes, but a database owner can alter the software. This is not a tamper-proof archive. Original import fields are retained and may contain personal information. Restrict access to the database, reports, drafts and exports.
