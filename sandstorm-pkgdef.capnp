@0xb4bf81c2da517923;

using Spk = import "/sandstorm/package.capnp";
# This imports:
#   $SANDSTORM_HOME/latest/usr/include/sandstorm/package.capnp
# Check out that file to see the full, documented package definition format.

const pkgdef :Spk.PackageDefinition = (
  # The package definition. Note that the spk tool looks specifically for the
  # "pkgdef" constant.

  id = "mkqyz71cc96e8gmq2h4dhnfm56k90t2055muv33h2ptw1q6h8n4h",
  # Your app ID is actually its public key. The private key was placed in
  # your keyring. All updates must be signed with the same key.

  manifest = (
    # This manifest is included in your app package to tell Sandstorm
    # about your app.

    appTitle = (defaultText = "Ghost"),

    appVersion = 10,  # Increment this for every release.

    appMarketingVersion = (defaultText = "0.2.0"),

    actions = [
      # Define your "new document" handlers here.
      ( title = (defaultText = "New Ghost Blog or Website"),
        command = .myCommand
        # The command to run when starting for the first time. (".myCommand"
        # is just a constant defined at the bottom of the file.)
      )
    ],

    continueCommand = .myCommand
    # This is the command called to start your app back up after it has been
    # shut down for inactivity. Here we're using the same command as for
    # starting a new instance, but you could use different commands for each
    # case.
  ),

  sourceMap = (
    # Here we defined where to look for files to copy into your package. The
    # `spk dev` command actually figures out what files your app needs
    # automatically by running it on a FUSE filesystem. So, the mappings
    # here are only to tell it where to find files that the app wants.
    searchPath = [
      ( sourcePath = "." ),  # Search this directory first.
      ( sourcePath = "/opt/sandstorm/latest/usr/include/sandstorm", packagePath = "node_modules" ),
      ( sourcePath = "/",    # Then search the system root directory.
        hidePaths = [ "home", "proc", "sys" ]
        # You probably don't want the app pulling files from these places,
        # so we hide them. Note that /dev, /var, and /tmp are implicitly
        # hidden because Sandstorm itself provides them.
      ),
      ( sourcePath = "/usr/local/lib/libkj-0.6-dev.so", packagePath = "usr/lib/libkj-0.6-dev.so" ),
      ( sourcePath = "/usr/local/lib/libkj-async-0.6-dev.so", packagePath = "usr/lib/libkj-async-0.6-dev.so" ),
      ( sourcePath = "/usr/local/lib/libcapnp-0.6-dev.so", packagePath = "usr/lib/libcapnp-0.6-dev.so" ),
      ( sourcePath = "/usr/local/lib/libcapnpc-0.6-dev.so", packagePath = "usr/lib/libcapnpc-0.6-dev.so" ),
      ( sourcePath = "/usr/local/lib/libcapnp-rpc-0.6-dev.so", packagePath = "usr/lib/libcapnp-rpc-0.6-dev.so" ),
      ( sourcePath = "/opt/sandstorm/latest/usr/include", packagePath = "usr/include" )
    ]
  ),

  fileList = "sandstorm-files.list",
  # `spk dev` will write a list of all the files your app uses to this file.
  # You should review it later, before shipping your app.

  alwaysInclude = ["themes", "core", "node_modules"]
  # Fill this list with more names of files or directories that should be
  # included in your package, even if not listed in sandstorm-files.list.
  # Use this to force-include stuff that you know you need but which may
  # not have been detected as a dependency during `spk dev`. If you list
  # a directory here, its entire contents will be included recursively.
);

const myCommand :Spk.Manifest.Command = (
  # Here we define the command used to start up your server.
  argv = ["/sandstorm-http-bridge-old", "8080", "--", "./run-ghost.sh"],
  environ = [
    # Note that this defines the *entire* environment seen by your app.
    (key = "PATH", value = "/usr/local/bin:/usr/bin:/bin")
  ]
);
