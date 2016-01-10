Australopithecus - NodeGroups
=============================


1. What is a node group?
------------------------

Nodes can be assigned to groups, this is mostly needed for dig speeds and
if you want to do something generic without needing to know eveyr single node
which requires this treatment.


2. Groups
---------

By default the system provides various groups and mechanics which can be used.

### 2.1 spreads_on_dirt (spread_minimum_light, spread_maximum_light)

Designates that this node does spread on dirt, that means that if there is
a dirt node around this node, the dirt node will eventually be converted into
this node.

The group does accept a DigSpeed value to designate the speed with which it
will spread.

Additionally one can attach two additional groups, spread_minimum_light and 
spread_maximum_light, which designate light values (inclusive) which are needed
for this node to spread.

### 2.2 attached_to_facedir

Designates that this node is attached to the node in its facedir value.

That means that this node will be dropped if the attached to node is mined.

### 2.3 attached_to_wallmounted

Designates that this node is attached to the node in its wallmounted value.

That means that this node will be dropped if the attached to node is mined.

### 2.4 becomes_dirt

Designates that this node turns into dirt as soon as another node is placed
on top of it, as long as the node that is placed on it does not have the group
"preserves_below_node" and is walkable.

### 2.4 preserves_below_node

Designates that this node does not trigger the becomes_dirt mechanic.

### 2.5 preserves_below_node_when_wallmounted

Same as preserves_below_node, except that it only preserves the below node if
it is not mounted on a wall or the ceiling.

### 2.6 simple_wallmounted

Designates that this node uses a simple wallmounted variant, the node must have
"facedir" as `paramtype2`. The simple wallmounted group makes sure that the top
of the node is always facing towards the player if placed, which means that it
will be rotated by 90 degrees if placed on a whole, and 180 degrees when placed
on the ceiling.

