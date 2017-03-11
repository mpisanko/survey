compile:
	mix do deps.get, compile

install:
	mix escript.build

clean:
	mix clean
