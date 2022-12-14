extends Node2D
class_name GraphManager

# node settings + properties
var nodeSettings = preload("res://resources/Nodes/node_settings.tres")
var edgeSettings = preload("res://resources/Edges/edge_settings.tres")

var graphs = {}
var selectedGraph = null

func _ready():
	load_test_graph2()
	save_graph(selectedGraph, "/home/julius/test_graph2")
#	load_graph("/home/julius/test_graph2")
	
	load_test_graph1()
	save_graph(selectedGraph, "/home/julius/test_graph1")
#	load_graph("/home/julius/test_graph1")
	

func create_node(type : Array):
	# find the node type template
	var subDict = $Types.nodeTypes
	var nodeType = null
	for subType in type:
		if not subType in subDict.keys():
			print("Not a known node type: ", subType)
			return
		
		if subDict[subType][1] == null or subType == type[-1]:
			nodeType = subDict[subType][0]
		else:
			subDict = subDict[subType][1]

	# create node
	var newNode = nodeType.duplicate()
	newNode.settings = nodeSettings
	newNode.visible = true
	
	return newNode

func create_node_with_properties(properties : NodePropertiesResource):
	var newNode = create_node(properties.type)
	newNode.properties = properties
	newNode.update_properties()
	return newNode

func create_edge(type : Array):
	# find the edge type template
	var subDict = $Types.edgeTypes
	var edgeType = null
	for subType in type:
		if not subType in subDict.keys():
			print("Not a known edge type: ", subType)
			return
		
		if subDict[subType][1] == null or subType == type[-1]:
			edgeType = subDict[subType][0]
		else:
			subDict = subDict[subType][1]

	# create edge
	var newEdge = edgeType.duplicate()
	newEdge.settings = edgeSettings
	
	return newEdge

func create_edge_with_properties(properties : EdgePropertiesResource):
	var newEdge = create_edge(properties.type)
	newEdge.properties = properties
	return newEdge

func create_graph(type : Array):
	# find the edge type template
	var subDict = $Types.graphTypes
	var graphType = null
	for subType in type:
		if not subType in subDict.keys():
			print("Not a known graph type: ", subType)
			return
		
		if subDict[subType][1] == null or subType == type[-1]:
			graphType = subDict[subType][0]
		else:
			subDict = subDict[subType][1]
	
	# create graph
	var newGraph = graphType.duplicate()
	newGraph.visible = true
	
	return newGraph

func create_graph_with_properties(properties : GraphPropertiesResource):
	var newGraph = create_graph(properties.type)
	newGraph.properties = properties
	return newGraph

# make new graph and select it
func add_graph(graph):
	$Graphs.add_child(graph)
	graphs[graph.properties.name] = graph
	selectedGraph = graph
	hightlight_selected_graph()

# functions
func load_test_graph1():
	print("load_test_graph1")
	# make new graph
	var testGraph = create_graph(["Base"])
	testGraph.properties = GraphPropertiesResource.new()
	testGraph.properties.name = "Test Graph 1"
	testGraph.properties.type = ["Base"]
	testGraph.properties.directed = false
	testGraph.update_properties()
	
	# add nodes + edges
	var paradiseNode = create_node(["Base", "Place"])
	paradiseNode.properties = NodePropertiesResource.new()
	paradiseNode.properties.name = "Paradise"
	paradiseNode.properties.type = ["Base", "Place"]
	paradiseNode.properties.position = Vector2(0, 0)
	paradiseNode.update_properties()
	testGraph.add_node(paradiseNode)
	
	var adamNode = create_node(["Base", "Actor"])
	adamNode.properties = NodePropertiesResource.new()
	adamNode.properties.name = "Adam"
	adamNode.properties.type = ["Base", "Actor"]
	adamNode.properties.position = Vector2(100, 100)
	adamNode.update_properties()
	testGraph.add_node(adamNode)
	
	var adamParadiseEdge = create_edge(["Base"])
	adamParadiseEdge.properties = EdgePropertiesResource.new()
	adamParadiseEdge.properties.type = ["Base"]
	testGraph.add_edge(adamParadiseEdge, adamNode, paradiseNode)
	
	var eveNode = create_node(["Base", "Actor"])
	eveNode.properties = NodePropertiesResource.new()
	eveNode.properties.name = "Eve"
	eveNode.properties.type = ["Base", "Actor"]
	eveNode.properties.position = Vector2(100, -100)
	eveNode.update_properties()
	testGraph.add_node(eveNode)
	
	var eveParadiseEdge = create_edge(["Base"])
	eveParadiseEdge.properties = EdgePropertiesResource.new()
	eveParadiseEdge.properties.type = ["Base"]
	testGraph.add_edge(eveParadiseEdge, eveNode, paradiseNode)
	
	var eveAdamEdge = create_edge(["Base"])
	eveAdamEdge.properties = EdgePropertiesResource.new()
	eveAdamEdge.properties.type = ["Base"]
	testGraph.add_edge(eveAdamEdge, eveNode, adamNode)
	
	add_graph(testGraph)
	testGraph.update()


func load_test_graph2():
	# make new graph
	var testGraph = create_graph(["Base"])
	testGraph.properties = GraphPropertiesResource.new()
	testGraph.properties.name = "Test Graph 2"
	testGraph.properties.type = ["Base"]
	testGraph.properties.directed = false
	testGraph.update_properties()
	
	var rootNode = create_node(["Base", "Root"])
	rootNode.properties = NodePropertiesResource.new()
	rootNode.properties.name = "Root"
	rootNode.properties.type = ["Base", "Root"]
	rootNode.properties.position = Vector2(-100, 0)
	rootNode.update_properties()
	testGraph.add_node(rootNode)
	
	var worldNode = create_node(["Base", "Place"])
	worldNode.properties = NodePropertiesResource.new()
	worldNode.properties.name = "World"
	worldNode.properties.type = ["Base", "Place"]
	worldNode.properties.position = Vector2(-200, 0)
	worldNode.update_properties()
	testGraph.add_node(worldNode)
	
	var rootWorldEdge = create_edge(["Base"])
	rootWorldEdge.properties = EdgePropertiesResource.new()
	rootWorldEdge.properties.type = ["Base"]
	testGraph.add_edge(rootWorldEdge, worldNode, rootNode)
	
	add_graph(testGraph)
	testGraph.update()

func show_all_graphs():
	for graphName in graphs:
		graphs[graphName].show_all_nodes()
		graphs[graphName].show_all_edges()

func dim_all_graphs():
	for graphName in graphs:
		graphs[graphName].dim_all_nodes()
		graphs[graphName].dim_all_edges()

func hightlight_selected_graph():
	dim_all_graphs()
	
	if selectedGraph == null:
		return
	
	selectedGraph.show_all_nodes()
	selectedGraph.show_all_edges()

func save_graph(graph, graphDirPath : String):
	# remove if directory already exists
	var directory = Directory.new()
	if graphDirPath[-1] != "/":
		graphDirPath += "/"
	if directory.dir_exists(graphDirPath):
		directory.remove(graphDirPath)
	directory.make_dir_recursive(graphDirPath)
	
	# save nodes
	var nodeDirPath = graphDirPath + "nodes/"
	directory.make_dir(nodeDirPath)
	
	var nodePaths = []
	for nodeIdx in graph.nodes.size():
		var nodePath = nodeDirPath + str(nodeIdx) + ".tres"
		ResourceSaver.save(nodePath, graph.nodes[nodeIdx].properties)
		nodePaths.append(nodePath)
	graph.properties.nodePaths = nodePaths
	
	# save edges
	var edgeDirPath = graphDirPath + "edges/"
	directory.make_dir(edgeDirPath)
	
	var edgePaths = []
	for edgeIdx in graph.edges.size():
		var edgePath = edgeDirPath + str(edgeIdx) + ".tres"
		ResourceSaver.save(edgePath, graph.edges[edgeIdx].properties)
		edgePaths.append(edgePath)
	graph.properties.edgePaths = edgePaths
	
	# save graph
	var graphPath = graphDirPath + "graph.tres"
	ResourceSaver.save(graphPath, graph.properties)

func load_graph(graphDirPath : String):
	var directory = Directory.new()
	if graphDirPath[-1] != "/":
		graphDirPath += "/"
	if not directory.dir_exists(graphDirPath):
		print("Not a directory: ", graphDirPath)
		return
	
	# load graph
	var graphPath = graphDirPath + "graph.tres"
	var graphProperties = load(graphPath)
	var loadedGraph = create_graph_with_properties(graphProperties)

	# load nodes
	for nodePath in graphProperties.nodePaths:
		var nodeProperties = load(nodePath)
		print(nodeProperties.type)
		var loadedNode = create_node_with_properties(nodeProperties)
		loadedGraph.get_node("Nodes").add_child(loadedNode)
		loadedGraph.nodes.append(loadedNode)
	
	# load edges
	for edgePath in graphProperties.edgePaths:
		var edgeProperties = load(edgePath)
		print(edgeProperties.type)
		var loadedEdge = create_edge_with_properties(edgeProperties)
		loadedGraph.get_node("Edges").add_child(loadedEdge)
		loadedGraph.edges.append(loadedEdge)
	
	add_graph(loadedGraph)
	loadedGraph.update()
	
