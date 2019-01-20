# Ruby-Redis

This is a redis prototype written in ruby.

**Steps to follow before complilation:**

  1. Add the .json DB file to the resource folder.

  2. Run the update_config.rb file. This is only for first time after that this file can be deleted. This step is done to update the source directory of this folder onto the config.yml file.
    
    ```
    $ ruby update_config.rb
    ```
  
  3. Install telnet on your system. If you already have ignore this step.

**Compilation/Running instructions :**

  1. To run the server just run ruby file, ruby_redis.rb followed by the filename without the extension.
		
    $ ruby ruby_redis.rb file_name

    Example : $ruby ruby_redis.rb redis_data 
    This is load redis_data.json to the server.

  2. Telnet is the client and can be accessed using command following command on a terminal.

    $ telnet 127.0.0.1 15000

**Commands recap:**
  
  These are all the commands:
  
    $ ruby update_config.rb
    $ ruby ruby_redis.rb file_name #on one terminal
    $ telnet 127.0.0.1 15000 #on another terminal