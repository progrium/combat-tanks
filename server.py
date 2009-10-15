from twisted.python import log
from twisted.internet import reactor, protocol
from twisted.protocols.basic import LineReceiver
import sys
import simplejson

GAME_PORT = 3333

class GameProtocol(LineReceiver):
    delimiter = "\n"
    number = None
    game = None
    
    def lineReceived(self, line):
        command, payload = line.split('::')
        if command != 'PING':
            print self.number, ">>", line
        payload = simplejson.loads(payload) if payload else None
        getattr(self, command.lower())(payload)
    
    def send(self, command, payload=None):
        payload = simplejson.dumps(payload) if payload else ""
        line = '%s::%s' % (command.upper(), payload)
        if command != 'pong':
            print self.number, "<<", line
        self.sendLine(line)
    
    def ready(self, payload):
        for player in self.game:
            if player != self:
                self.send('player', {'player': player.number})
        self.send('ready')
    
    def _relay(self, cmd, payload={}):
        payload.update({'player':self.number})
        for player in self.game:
            if player != self:
                player.send(cmd, payload)
    
    def hit(self, payload):
    	self._relay('hit')
    
    def shoot(self, payload):
        self._relay('shoot')
    
    def state(self, payload):
        self._relay('state', payload)
        
    def move(self, payload):
        self._relay('move', payload)
        
    def ping(self, payload):
        self.send('pong', payload)
    
    def findgame(self, payload):
        if len(self.factory.waitingPlayers) == 0:
            self.factory.waitingPlayers.append(self)
            self.send('wait')
        else:
            game = [self.factory.waitingPlayers.pop(0), self]
            self.factory.games.append(game)
            for player in game:
                player.number = game.index(player)
                player.game = game
                player.send('start', {'player': player.number})
            

class GameFactory(protocol.ServerFactory):
    protocol = GameProtocol
    waitingPlayers = []
    games = []

class PolicyProtocol(protocol.Protocol):
    def dataReceived(self, line):
        if "/>" in line:
            self.transport.write("<cross-domain-policy>\n<site-control permitted-cross-domain-policies=\"all\"/>\n<allow-access-from domain=\"*\" to-ports=\"%s\"/>\n</cross-domain-policy>\n" % GAME_PORT)
            self.transport.loseConnection()
    
class PolicyFactory(protocol.ServerFactory):
    protocol = PolicyProtocol

log.startLogging(sys.stdout)
reactor.listenTCP(GAME_PORT, GameFactory())
reactor.listenTCP(843, PolicyFactory())
reactor.run()