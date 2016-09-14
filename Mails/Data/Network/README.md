### Weighting
The full network has many edges, some of them representing a weak link of a single occurence of posting in the same thread for
2 individuals: we use the code backbone.r to identify the most significant links and extract the backbone of this network.

As the weight of an edge depends on the number of mails sent by each user, we cannot simply select the edges with higher weight.
Indeed, the more two person post, the more the probability to find them in the same thread increases. To take this effect into account, we evaluate the nature of the influence between both parameters. We used this relationship to identify the edges having a weight significantly superior than the one expected from simple randomness.
The simplified network extracted by this method is registered in files nodesWeighted.txt and edgesWeighted.txt

backbone.r takes the path of folder "Data", a matrix containing the weighted edegs of total network and a vector of boundaries
to aggregate the results. It can be launched with subGraph.r, in the root folder of this projet, in which a set of parameters for this work is already implemented.
