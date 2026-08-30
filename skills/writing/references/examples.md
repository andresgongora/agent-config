---
name: examples
description: "Fact-preserving worked pairs for high-judgment composition decisions and missing-fact handling."
---

# Worked Examples

Every Better, Ask, and draft output uses only facts stated in its "Given" line. Weak text may deliberately show unsupported invention or overstatement; never use it as source.

## Direct peer-level request

Given: _Recipient must review proposal and send decision. Deadline and reason not supplied._

- Weak: _I hope you are well. If it is not too much trouble, would you perhaps be able to review this proposal at your earliest convenience?_
- Better: _Please review the proposal and send your decision._

Signal: state action directly. Do not invent deadline, attachment, or business consequence.

## Missing material fact

Given: _User wants an announcement about a service interruption and organization will provide next update. Cause, restoration time, required customer action, and update time unknown_.

- Weak: _[confirm: affected service] was interrupted. [confirm: required customer action]. Next update: [confirm: time]._
- Ask user before drafting: "What service was interrupted, what do customers need to do now, and when is next update due?"
- User answer: "Github will be interrupted for maintenance. Customers should not attempt to push or pull code. Next update will be at 3:00 PM EDT."
- Better: _Github will be interrupted for maintenance. Customers should not attempt to push or pull code. Next update will be at 3:00 PM EDT._

Signal: ask when missing fact controls reader action. Do not leave placeholders in place or fabricate them.

## Claim, mechanism, impact

Given: _Draft says "Our deployment process is slow. We should improve it." No mechanism, measurement, or impact supplied._

- Weak: _Our deployment process is slower than it should be, and improving it should be a priority for the team._
- Ask user before drafting: "What makes deployment slow, how long does it take, and what does the delay cost? Is a fix already proposed?".
- User answer: "Deployment takes 40 minutes because test and build stages run sequentially on one CI runner. This delays same-day releases. Team proposes running stages in parallel to remove the bottleneck."
- Better: _Deployments take 40 minutes because test and build stages run sequentially on one CI runner. This delays same-day releases. Team proposes running the stages in parallel to remove the bottleneck._

Signal: the weak version is the vague draft polished, which no rewriting can fix. Ask for mechanism and impact, then write only what the answer supplied. No forecasted savings, no invented cause.

## Calibrated uncertainty

Given: _Team identified two possible causes of failed payments. Investigation continues. No customer action required._

- Weak: _We know what caused the payment failures and will fix them soon._
- Better: _We identified two possible causes of the payment failures. Investigation continues. No action is required from customers._

Signal: distinguish known fact, uncertainty, and next action.

## Non-material fact

Given: _Email asks reader to review proposal. Writer has no evidence that delay is common._

- Better: _Please review the proposal._

Signal: omit unsupported color when it does not change reader action.

## Judgment, not fact

Given: _User requests recommendation. Vendor A meets three stated requirements. No outcome data compares vendors._

- Better: _I recommend Vendor A because it meets the three stated requirements._

Signal: identify recommendation as judgment. The reason is supplied and only outcome proof is missing, so label it rather than asking. Do not claim unmeasured outcome. A correspondence body that is a recommendation plus its supplied reason is an exempt structure, not a three-function paragraph.

## Substantive paragraph: three functions

Given: _Support queue grew from 40 to 120 open tickets in March. Two of five agents left in February and were not replaced. Median first reply moved from 4 hours to 19 hours._

- Weak: _Two of five agents left in February. Median first reply moved from 4 hours to 19 hours._
- Better: _The support backlog followed a staffing loss. Two of five agents left in February and were not replaced, and open tickets grew from 40 to 120 during March. Median first reply moved from 4 hours to 19 hours over the same period._

Signal: the weak version is body only, with no stated idea and no consequence. Opening names the core idea, body develops it, closing states the measured outcome. The opening claims sequence, not proven cause, because no supplied fact rules out other explanations.

## Exempt structure: decision plus required action

Given: _Proposal is approved. Recipient must begin purchase process._

- Better: _The proposal is approved. Please begin the purchase process._

Signal: a correspondence body that is only a decision and its required action is exempt from the three-part form. Do not pad it into an argument paragraph.

## Nominalization / hidden verb

- Weak: _The establishment of a different approach on the part of the committee has become a necessity._
- Better: _The committee has to approach it differently._

Signal: find the buried verb (`establishment` → `establish`), name the actor, cut the noun scaffolding around it. Source: Joseph M. Williams, *Style: Lessons in Clarity and Grace* (1985), p. 11, via University of Wisconsin–Madison Writing Center, <https://writing.wisc.edu/handbook/ccs_actionverb/>.

## Passive voice: buried actor

- Weak: _A notice must be given by the Secretary of State._
- Better: _The Secretary of State must give a notice._

Signal: passive is not wrong by default; it is wrong here because the actor is known and the sentence buries it. When the actor is unknown, irrelevant, or the passive form is clearer, keep it. Source: UK Office of Parliamentary Counsel, drafting guidance for bills, 19 March 2024, <https://www.gov.uk/government/publications/drafting-bills-for-parliament/2024-03-19-drafting-guidance>.

## Hedging: unsupported universal claim

Given: _Source data shows a correlation across a studied population, not a universal law._

- Weak: _Children living in poverty do poorly in school._
- Better: _Children living in poverty tend to do poorly in school._

Signal: one calibrated hedge word carries the whole correction; do not stack more than the claim needs. Source: Swales & Feak, *Academic Writing for Graduate Students* (2004), via George Mason University Writing Center, <https://writingcenter.gmu.edu/writing-resources/writing-as-process/hedging>.

## Sentence length: split without deleting the warranted hedge

- Weak: _Although the subjects with high CACSs may be at higher risk of a first event, further follow-up data are needed before EBT screening can be recommended for type 1 diabetic patients._
- Better: _The subjects with high CACSs may be at higher risk of a first event. But further follow-up data are needed before EBT screening can be recommended for type 1 diabetic patients._

Signal: splitting a long qualified sentence into two plain ones keeps every hedge and every clause; it only removes the subordinating scaffold. Peer-reviewed measurement: cloze-comprehension rose from 35.8% to 43.6% after this kind of split. Source: Kandula, Curtis & Zeng-Treitler, AMIA Annual Symposium Proceedings (2010), <https://pmc.ncbi.nlm.nih.gov/articles/PMC3041424/>.
