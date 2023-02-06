extends Node

const DEFAULT_PORT = 28960
const MAX_CLIENTS = 6

var server = null
var client = null
var ip_adress = "127.0.0.1"

func _ready():
	get_tree().connect("connected_to_server",  self, "_connected_to_server")
	get_tree().connect("server_disconnected",  self, "_server_disconnected")
	get_tree().connect("connection_failed",  self, "_connection_failed")
	get_tree().connect("network_peer_connected",  self, "_player_connected")
	
func create_server():
	print("Create server! Juhí")
	server = NetworkedMultiplayerENet.new()
	server.create_server(DEFAULT_PORT, MAX_CLIENTS)
	get_tree().set_network_peer(server)
	
func join_server():
	print("Join server! server! Juhí")
	client = NetworkedMultiplayerENet.new()
	client.create_client(ip_adress, MAX_CLIENTS)
	get_tree().set_network_peer(client)

func _connected_to_server():
	print("Megyen")

func _server_disconnected():
	print("Nem megyen")
	
	reset_network_connection()
	
func _connection_failed():
	print("Minden úgy rossz ahogy van")
	reset_network_connection()
	
func reset_network_connection():
	if get_tree().has_network_peer():
		get_tree().network_peer = null
		
func _player_connected(id):
	print("Megyen a Player" + str(id))
