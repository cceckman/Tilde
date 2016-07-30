// %DATE% %USER% <%MAIL%>
package main

import(
	"flag"
	"fmt"
	"os"
)

var(
	help = flag.Bool("help", false, "Display a usage message.")
)

func man() {
	flag.Usage = func() {
		fmt.Fprintf(os.Stderr, "%s:	%HERE% \nUsage:\n", os.Args[0])
		flag.PrintDefaults()
	}
	flags.Parse()
	if *help {
		flag.Usage()
		os.Exit(1)
	}
	// Above is boilerplate.

}
