# Additional Files
[apache2.conf](apache2.conf)

[mime.types](mime.types)

# Telematic Applications: Web Servers (HTTP)

In this assigment, we will configure an Apache Web Server version 2.4.X and test its functionality by sending HTTP requests and analyzing the responses.
In the lab, we have an Apache server installed in the /usr/sbin/ directory. By default, Apache retrieves configuration information from the file `/etc/apache2/apache2.conf`.
However, we will use our own configuration file to test different options and adapt it to our needs.

Above you have two files to download for the practice (`apache2.conf` and `mime.types`).
The first one (`apache2.conf`) contains directives necessary to launch the server and specific directives related to its behavior.
The second file (`mime.types`) contains the list of MIME types related to the content served by the server. The structure of this file is simple: type/subtype and the extension associated with that type.

## Server Configuration
Before running the server, we need to modify several directives. For detailed information on any of them, you can refer to [Apache Directives](http://httpd.apache.org/docs/mod/directives.html).
<p></p>
<ol>
<li>
<p>Prepare your account by downloading the necessary files into it and creating the following directory structure, where <tt>d</tt>
indicates a directory or folder, and <tt>f</tt> indicates a file:</p>
<blockquote>
<pre>d-httpd                    (root directory of the server "<tt>ServerRoot</tt>")
f--- apache2.conf
f--- mime.types
d--- defaultdocs
d--- log
d--- vhost1
d    --- docs
d    --- log
d--- vhost2
d    --- docs
d    --- log
</pre>
</blockquote>
</li>

<li>Next, we will modify certain directives to point to files in our account and to determine certain execution parameters. Open `apache2.conf` and change the directives:
<ul>
<li><b>ServerRoot</b>: path to the directory where the necessary configuration files for the correct operation of the server are located
(absolute path to the <tt>httpd</tt> directory in your account).</li>
<li><strong><tt>ServerName</tt></strong>: name of the machine where the server is hosted.</li>
<li><strong><tt>Listen</tt></strong>: specify as port 9xxx, where xxx corresponds to the last 3 numbers of the machine's IP address.</li>
</ul>
Other directives like <strong><tt>DocumentRoot</tt></strong>, <strong><tt>LockFile</tt></strong>, <strong><tt>PidFile</tt></strong>, <strong><tt>ScoreBoardFile</tt></strong>,
<strong><tt>ErrorLog</tt></strong>, <strong><tt>CustomLog</tt></strong>, and <strong><tt>TypesConfig</tt></strong> indicate directory or file names (created by the server)
relative to the path specified in <b><tt>ServerRoot</tt></b>.
</li>

<li>Create a simple web page <tt>aptel.html</tt> in <tt>httpd/defaultdocs</tt>, for example:
<blockquote>
<pre>
&lt;html>
&lt;body>
¡Hola mundo!
&lt;/body>
&lt;/html>
</pre>
</blockquote>
</li>

<li>Now we can <span style="font-weight: bold;">start our server</span> by specifying the adapted configuration file. Use the command:
<pre>/usr/sbin/apache2 -f $FULL_PATH/apache2.conf</pre>

<p>Verify that the server is running: use the <tt>ps</tt> command or open the <tt>apache2.pid</tt> file
(if this file does not exist, the server is not running—check the logs to detect the problem).</p>
</li>

<li>Access the newly created page (aptel.html) through the browser at the URL <tt>http://servername:port/aptel.html</tt>.
Also, try accessing it using simply <tt>http://servername:port/</tt>.

<p>Note that if we do not specify the HTML page we want to access, the server can act in two ways:</p>
<ul>
<li>Showing a list of directories (not recommended), or</li>
<li>Displaying a default HTML file.</li>
</ul>

<p>For the second behavior, the <b><tt>DirectoryIndex</tt></b> directive is used to specify the name of the default file.
Make sure this directive is already defined and is typically <tt>index.html</tt>. For now, do not modify this directive.</p>

<p><strong>Note:</strong> If there is an error, investigate what is happening by accessing the file configured in the <tt>ErrorLog</tt> directive.</p>
</li>
</ol>

<h3>HTTP Requests and Responses</h3>
Once we have verified the operation of our server using the browser as a client, let's use a <tt>telnet</tt> client.

<ol start="6">
<li>Make the requests made earlier with the browser <tt>http://your_machine:your_port/aptel.html</tt> and
<tt>http://your_machine:your_port/</tt> using <tt>telnet</tt>. Send requests using HTTP/0.9 and HTTP/1.0. What responses and headers do you get?</li>

<li>Repeat the requests using HTTP/1.1. What header should you include in the request? Does the server immediately close the connection?
What should be included in the request for it to do so? Test it.</li>

<li>Even if nothing is sent in the HTTP/1.1 request to immediately close the connection, the server does so after a period of inactivity.
Measure how long this time is and check that it matches what is specified in the <b><tt>KeepAliveTimeout</tt></b> directive.</li>

<li>Look at the <tt>apache2.conf</tt> file and explain the purpose of the <b><tt>KeepAlive</tt></b> and <b><tt>MaxKeepAliveRequests</tt></b> directives.</li>
</ol>

<h3>Processes and Resources in the Web Server</h3>
<ol start="10">
<li>Check how many processes are running. To do this, run the command <tt>ps -x</tt>.

<p>This number can be controlled with the <tt>StartServers</tt> directive. The server initially starts this number of child processes to handle traffic,
although it starts and stops new child processes dynamically as needed (the maximum number is controlled by the <tt>MaxClients</tt> directive,
also see <tt>MinSpareServers</tt> and <tt>MaxSpareServers</tt>).</p>

<p>Modify the configuration file to start by default 8 child processes.</p>

<p><strong>Note:</strong> Remember that changes to the server will take effect once it is restarted. To stop the server, use the <tt>-k stop</tt>
option of <tt>/usr/sbin/apache2...</tt> or the <tt>kill</tt> command along with the process number.
</li>
</ol>

<h3>Logs Management</h3>
Apache server generates interesting logs about its operation. On one hand, the error log and on the other, the access log.
<ol start="11">
<li>The error log is in the file indicated by the <b><tt>ErrorLog</tt></b> directive.
The <b><tt>LogLevel</tt></b> directive can vary the level of detail in the log.
Examine the error log file and increase the level of detail to "debug", restart the server, and check how, for the same type of requests,
a greater number of records is stored.</li>

<li>The <b><tt>CustomLog</tt></b> directive indicates the file where access to our web will be recorded.
Examine the access log file. As you can see, machines are identified only by their IP. Find out which <tt>apache2.conf</tt> directive you need to change
to ensure that the access log displays the machine's name ("hostname") instead of the IP. Make the change and verify that it works.</li>
</ol>

<h3>Content Types in Apache</h3>
As you may have seen when making the queries from questions 6 and 7, the server tells us the MIME type (Content-Type) of the object it sends.
To know the MIME type of an object, check its extension in the file indicated in the <tt>TypesConfig</tt> directive.
<ol start="13">
<li>Create a copy of the <tt>aptel.html</tt> file with the name <tt>test.aptel</tt> and change the directive so that <tt>test.aptel</tt> is the default file sent.
Make requests to <tt>http://your_machine:your_port/test.aptel</tt> with a browser and with telnet. How do you see the file in the browser? What MIME type is the file sent with? Why?</li>

<li>Change the configuration so that when the extension is "aptel," it returns the MIME type <tt>application/x-type-aptel</tt>.
Check that it works correctly. What does the web browser do now? Test with different browsers, e.g., Chrome and Firefox.</li>
</ol>

<h3>Directory Management and Security</h3>
The configuration for a specific directory can be changed using the <tt>&lt;Directory&gt;</tt> directive. For example, add the following code at the end of the apache2.conf file
(replacing <tt>DOCUMENT_ROOT</tt> with the full path to the appropriate directory according to your web server configuration):
<blockquote>
<pre>
&lt;Directory DOCUMENT_ROOT/internal>
    AuthType Basic
    AuthName "Telematic Applications"
    AuthUserFile SERVER_ROOT/passwd
    Require user aptel
&lt;/Directory>
</pre>
</blockquote>
<ol start="15">
<li>Create the <tt>DOCUMENT_ROOT/internal</tt> directory (within your folder specified in the <tt>DocumentRoot</tt> directive, <tt>defaultdocs</tt>) and copy the <tt>aptel.html</tt> file into it. Remember to add this filename to the default files that are sent.
What happens now when you try to access the URL <tt>http://your_machine:your_port/internal</tt> with a browser?

<p><strong>Note:</strong> You can add a small text (for example, change the message to ¡Hola Mundo interno!) to the file if you want to differentiate it.</p>
</li>

<li>You will need to generate the password file (<tt>SERVER_ROOT/passwd</tt>), which can be done with the <tt>htpasswd</tt> utility.
Use this utility to create a file with a user <tt>aptel</tt> and password <tt>redes</tt>. Try to log in with this user and password using a web browser.
</li>

<li>Now try it using telnet. What is the realm name? Where does the server get it from?
Send a second request to access the page. You can use this [Base64 converter](https://www.base64encode.org/).</li>
</ol>

<h3>HTTP/2</h3>
<ol start="18">
<li><p>Make an HTTP/2 request to the website <tt>https://example.com</tt> using <tt>curl</tt> and <tt>nghttp</tt>. Ensure the request is made using HTTP/2.</p></li>
<ul>
<li>What headers are sent in the request?</li>
<li>What version of TLS does the website use?</li>
<li>How many streams are there?</li>
<li>What frame types are exchanged?</li>
<li>What differences can be observed between using the <tt>curl</tt> command and <tt>nghttp</tt>?</li>
</ul>
</ol>

<h3>Redirection and Virtual Hosts</h3>

<ol start="19">
<li><p>The <b><tt>Redirect</tt></b> directive allows redirecting a client from one URL to another. Use this directive to make browsers visiting the URL <tt>http://your_machine:your_port/old/</tt>
automatically redirected to <tt>http://your_machine:your_port/new/</tt>.</p></li>

<li><p>For this part, it is required to modify the directives <strong>within the <a href="https://httpd.apache.org/docs/2.4/vhosts/examples.html"><tt>VirtualHost</tt></a> directive</strong>: <tt>DocumentRoot</tt>, <tt>ServerAdmin</tt>, and <tt>ServerName</tt>.</li>The <b>&lt;VirtualHost&gt;</b> directive allows the server to respond to different web pages, depending on the server name used to access it. This name is sent with the Host header of HTTP/1.1.</p>

<p>Create two new pages <tt>aptel.html</tt> (with messages "&iexcl;Hola mundo vhost1!" and "&iexcl;Hola mundo vhost2!", respectively) and
copy them to the virtual hosts directories (at the end of the <tt>apache2.conf</tt> file). Test by sending telnet requests, changing the host header.</p>
</li>
</ol>
