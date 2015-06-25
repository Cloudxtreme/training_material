# The Claim Game
*Teaching Notes*

<br>
## Teaching Goals

The claim game is a practical interactive experience that tests and reinforces knowledge learned in dev modules `201`, `202` & `203`.

It is a simulation of a five-node Riak cluster performing simple PUT & GET operations, under both normal and failure conditions.

<br>

## Materials

+ one sharpie pen
+ a pack of sticky note paper, preferably long thin ones
+ a pack of index cards
+ five colored tokens (one each of red, green, blue, orange, purple)
+ five pencils
+ these notes
+ the accompanying "Letter Frequencies" pdf

## Preparation

Use the sharpie to write words on the sticky notes. You should write one word per note, which is why long, thin ones are best. Each word should be written **THREE** times, on three separate sticky notes. These three should be kept stuck together.

You can write any words you like. The game is better if you write a random selection of words chosen by an online generator. The more words you have, the longer the game can go on for.

Next, use the sharpie to write letters at the top of each index card. The letters you should write are as follows:

+ AA - AO
+ AO - AZ
+ B, G, Q
+ C, U
+ D, R
+ E, J, K
+ F, N
+ H, X, Z
+ I
+ M, L
+ O
+ P, V
+ S
+ TA - TI
+ TI - TZ
+ W, Y

You should write each group of letters **THREE** times, at the top of three separate index cards. Since there are 16 groups, you will therefore use 48 cards in total.

<br>

## Setup

Divide the participants into five teams of any size. Each team will be one of the five nodes in the cluster. These nodes are identified by color, so give each team the token representing their color. These will help other teams keep track of who's who.

Next, project the preflist color-chart from the "Letter Frequencies" pdf onto a suitable screen, or give each team a copy if no projector is available. The necessary parts are the grid of colors and the letter-group key identifying each row.

Each team should also be given a bunch of blank index cards and one pencil each.

Play may now begin.

<br>

## Play

### Phase One: Claim

In this phase, players warm up by claiming partitions that should belong to their team.

Each index card is a partition. Since `N=3`, there are three copies of each. Partitions are owned by nodes (teams) according to the preflist.

The game master should shout out the letter group on each set of index cards, while holding them up for all to see. Teams then call out or raise their hands to claim their partitions.

One could score this, awarding a point to the first team to call out for each card set. But scoring is not strictly necessary, as this is more a cooperative learning game, rather than a competitive one. If scoring, don't forget to keep tally, perhaps on a board or the projection screen.

---
### Phase Two: PUTs / GETs

Once all partition cards have been handed out, it's time to move to phase two. In this phase, nodes take turns being the coordinator, and the game master acts as the client.

To do a PUT, the client picks a sticky note group at random, calling out the word and holding it up for all to see. The client then passes the sticky notes to the current coordinator.

It is now the coordinator's job to figure out on which partitions the word should be stored, and on which nodes these partitions reside.

Doing the former is simple: the words are keyed by first letter. So, e.g. `adrenaline` would live in the `aa-ao` group, whereas `asbestos` would live in the `ao-az` category.

The latter requires reference to the preflist. The primaries for each letter group are the first three colors in the color chart from left to right.

Once the coordinator team believe they know where the words should go, they give one sticky note to each node (keeping one if it goes to themselves).

Each team receiving a note should attempt to stick it onto the appropriate partition. If the team does not have such a partition, this may mean the coordinating team has made an error.

If points are being awarded, the coordinator should get a point if they forward the data to the correct nodes.

Doing a GET is similar to doing a PUT. However, instead of distributing sticky notes, the coordinator simply asks the nodes it believes should have the data if they have it. They then respond with `data` or `not_found`.

---
### Phase Three: When Good Nodes Go Bad

In this dangerous phase, the game master may throw scrunched up pieces of paper at a node or two. This is a sign that the node should **go down**.

Coordinators then have the harder task of resolving GETs & PUTs when a primary may be unavailable. When putting data to a secondary, that node will not have the appropriate card. They should use one of their blank cards and write the letters in pencil at the top, along with the color of the primary it should be stored on. They then stick the object on this temporary partition card.

When sufficient amusement has occurred, the game master may then bring nodes back by "rebooting" them, perhaps by aiming a properly clad foot in their general direction. *Kicking students is not recommended*. The resurrected nodes should announce themselves to the ring, and all other node teams should begin hinted handoff if they have temporary partitions meant for the returning primary.

For advanced fun, have the coordinator run at differing R & W values, and be responsible for merging and read repair. Don't do this if people are already confused, it will only confuse them more! Also, make sure students know basic Riak merge rules (e.g. not_found can safely be ignored if there is data).

<br>

## Cleaning Up

Once the students have learned enough, the game ends.
Collect all index cards, strip the data from them, and collate data and cards into sets of three.
Collect the node tokens and pencils.
Rub out the pencil marks on the temporary partition cards.

Put everything in a bag.

Done!
<br>




















