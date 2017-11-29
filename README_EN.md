# Telematic applications: Web Servers Assignment

## Configuring a web server
In this assignment, we will configure an <a href="http://httpd.apache.org/">Apache</a> web server version 2.2.X and test its behaviour by sending HTTP requests and studying the replies.

A web server of that version is installed in the directory <tt>/usr/sbin/apache</tt> on the lab computers. By default, Apache obtains the configuration information from the file <tt>/etc/apache2/apache2.conf</tt>. However the configuration stored in that directory does not fit into our purposes and cannot be launched without root permissions. So we're going to make our own!!!

In aula global you can find three files to be downloaded (apache2.conf, httpd.conf and mime.types). The first one (apache2.conf) contains several general directives
that should be present to allow the server to run. At the end of this first file an include directive loads the second (httpd.conf). 
That second file (httpd.conf) contains directives specific to the content/behaviour of your server. We will modify serveral directives. 
If you need to more information (about any directive) have a look to <a href="http://httpd.apache.org/docs/mod/directives.html">http://httpd.apache.org/docs/mod/directives.html</a>.
The last one, <tt>mime.types</tt> contains a complete list of MIME types, which are a way to convey the document type information. The structure is very simple; it contains type/subtype and the file extension associated to this type.

<ol>
<li>
<p>Set up your account. Download the files to your account and create the folowing directory/file structure:</p>
<pre>d-httpd                    (this is your server root)
f--- apache2.conf
f--- httpd.conf
f--- mime.types
d--- defaultdocs
d--- log
f--- mime.types
d--- vhost1
d    --- doc
d    --- log
d--- vhost2
d    --- doc
d    --- log
</pre>
</li>
<li>First, we must modify certain directives so that they point to files in our account and to set certain execution parameters:
<ul>
<li>
<p>Open apache2.conf and change:</p>
<ul>
<li><b>ServerRoot</b>: indicates the directory in which files required for correct operation are to be found. Set it to point to a directory of your account (httpd).</li>
<li><strong><tt>LockFile</tt></strong></li>
<li><strong><tt>PidFile</tt></strong></li>
<li><strong><tt>ScoreBoardFile</tt></strong></li>
<li><strong><tt>User</tt></strong></li>
<li><strong><tt>Listen</tt></strong></li>
<li><strong><tt>ErrorLog</tt></strong></li>
<li><strong><tt>CustomLog</tt></strong></li>
<li><strong><tt>Include -- change the path of the last include (so it points to your account and the appropriate directory</tt></strong></li>
</ul>
</li>
<li>
<p>Open httpd.conf and change:</p>
<ul>
<li><b>ServerRoot</b>: indicates the directory in which files required for correct operation are to be found. Set it to point to a directory of your account (httpd).</li>
<li><strong><tt>DocumentRoot</tt></strong></li>
<li><strong><tt>first Directory path</tt></strong></li>
<li><strong><tt>TypesConfig</tt></strong></li>
<li><strong><tt>within the VirtualHost directive</tt></strong> change : ServerAdmin, ServerName, ErrorLog, CustomLog</li>
</ul>
</li>
</ul>
<p>Modify the <b>DocumentRoot</b> directive to specify the directory that contains the documents to be shown.</p>
</li>
<li>
<p>Create a very simple web page <tt>aptel.html</tt> in httpd/defaultdocs, for example:</p>
<blockquote>&lt;html&gt;<br> &lt;body&gt;<br> Hello World from default host<br> &lt;/body&gt;<br> &lt;/html&gt;</blockquote>
</li>
<li>Now we can <span style="font-weight: bold;">start our apache server</span>, do it indicating the configuration file we have just modified. First test the configuration and fix any defect:
<pre>     /usr/sbin/apache2 -f PATH/apache2.conf -t
</pre>
If everithing is correct, execute:
<pre>     /usr/sbin/apache2 -f PATH/apache2.conf
</pre>
<ul>
<li>Verify the server has started -&gt; Use command <tt>ps</tt> or open the <tt>apache2.pid</tt> (if the file does not exist, the server is not runiing -- have a look to the logs).</li>
</ul>
</li>
<li>Verify you can access the page just created (aptel.html) pointing your browser to <tt>http://servername:port/aptel.html</tt>. Try also to access using simply <tt>http://servername:port/</tt>. If there is an error, investigate the error file you previously defined in the directive <tt>ErrorLog</tt> (<a href="#errors">see also here</a>). <span style="font-weight: bold;">Note</span>: If the error is due to permissions, verify the characteristics allowed and disallowed in the <a href="https://httpd.apache.org/docs/2.0/mod/core.html#directory">directive <tt>&lt;Directory&gt;... &lt;/Directory&gt;</tt></a>. Which should you comment? Do the necessary changes restart the server and revisit the page.<br> Take into account that if we do not specify the HTML page we want to retrieve, the server may act in two different ways:
<ul>
<li>It can can either display a listing of the directory (not recommendable), or</li>
<li>it can show the contents of a default HTML file</li>
</ul>
</li>
<li>To obtain the latter behaviour, we use the <b>DirectoryIndex</b> directive to specify the name of the default file to be used in such cases. (usually <tt>index.html</tt>). Notice that in the <tt>apache2.conf</tt> file you are using, this directive is already defined and, for the moment, we will not need to alter it. <br>What pages can you visit? Why?</li>
</ol>
<h3>HTTP Request reply</h3>
<p>Once you have followed the previous steps, try the following:</p>
<ol start="7">
<li>Do the previous requests <tt>http://your_machine:your_port/aptel.html</tt>? And at <tt>http://your_machine:your_port/</tt> via telnet on the corresponding port. Send the requests via HTTP/0.9 y HTTP/1.0. What response headers do you obtain?</li>
<li>Now send the request via HTTP/1.1. What header must you include in the request? Does the server close the connection immediately? What must the request include for it to do so? Test this.</li>
<li>Even if you do not send anything in the HTTP/1.1 request to tell the server to close the connection immediately, it still does so after a certain length of time if there is no activity. Measure this time. Check that it coincides with the specified <b>KeepAliveTimeout</b> directive.</li>
<li>Check again the <tt>apache2.conf (or httpd-default.conf)</tt> file and see what <b>KeepAlive</b> and <b>MaxKeepAliveRequests</b> directives are for.</li>
</ol>
<h3>Processes and resources in the web server</h3>
<ol start="11">
<li>
<p>Use the <tt>ps -x</tt> command to find out how many server processes are executing (piping the output to a grep will make the visualization easier). This number can be controlled with the <b>StartServers</b> directive. The server initially starts this number of child processes to service requests, though it also dynamically starts and stops new child processes as needed (the maximum number is controlled with the <b>MaxClients</b> directive; see also <b>MinSpareServers</b> y <b>MaxSpareServers</b>, all in <tt>apache2.conf or httpd-mpm.conf</tt> file).</p>
<p>Remember that configuration changes, are only applied if you stop and restart the server (or reload the config file).</p>
</li>
<li>Stop the server using option <tt>-k stop</tt> of /usr/sbin/apache2, or the <tt>kill</tt> command together with the number of the process that is stored in the file specified in the <b>PidFile</b> directive.</li>
<li>Modify the file <tt>apache2.conf</tt> so that by default it starts 8 child processes.</li>
<li>Modify also httpd.conf that <tt>aptel.html</tt> is sent by default (which directive are you using?). You may also change the value of other directives presented in the above sections if you so wish. Restart the server and check that the changes have taken effect.</li>
</ol>
<h3><a name="errors"></a>Apache Logs</h3>
<p>The Apache server generates two log files containing interesting and useful information: the error log and the access log.</p>
<ol start="15">
<li>The error log is written to the file indicated in the <b>ErrorLog</b> directive. The level of detail of this log can be varied using the <b>LogLevel</b> directive. Study the contents of the error log, then increase the level of detail to "debug", restart the server and check that, for the same type of requests, more information is logged.</li>
<li>The access log is written to the file indicated by the <b>CustomLog</b> directive. It can be seen from studying the contents of this file that the machine accessing our web site is only identified by its IP address. Find out which directive of the <tt>http.conf</tt> must be changed in order for the machine name ("hostname") to appear in the access log instead of the IP address. Make the change and check that it works.</li>
</ol>
<h3>Content types in apache</h3>
<p>As you would have seen on questions 2 and 3, the server tells us the MIME type (Content-Type) of the object that it sends back to us. To obtain the MIME type for a given file extension, the server consults the configuration file specified in the <b>TypesConfig</b> directive (in httpd.conf). If the file extension in question is not one of the ones figuring in this file, the server sends the default MIME type as specified in the <b>DefaultType</b> directive.</p>
<ol start="17">
<li>Copy the file <tt>aptel.html</tt> to <tt>test.aptel</tt> and issue the request <tt>http://your_machine:your_port/test.aptel</tt> with a browser and with telnet. How is the file presented in the browser? What MIME type is the file sent with? Why?</li>
<li>Change the configuration (in mime.types --add a line) so that when the extension is <tt>aptel</tt> the MIME type is set to <tt>application/x-type-aptel</tt>. Check that it works correctly. What does the web browser do now?</li>
</ol>
<h3>Directory management and security</h3>
<p>The configuration can be changed for a given directory using the <b>&lt;Directory&gt;</b> directive. for example, add the following code at the end of the <tt>httpd.conf</tt> file (substituting <tt>DOCUMENT_ROOT</tt> for the full path of the root directory of your web site):</p>
<ol start="19">
<li>
<p>Change the folowing piece of code:</p>
<pre>&lt;Directory /var/home/lab/asignatura/labro/httpd/defaultdocs/&gt;
    Options Indexes Includes FollowSymLinks MultiViews
    AllowOverride None
    Order allow,deny
    Allow from all
&lt;/Directory&gt;
</pre>
<p>in httpd.conf to add security as follows</p>
<pre>&lt;Directory DOCUMENT_ROOT/internal&gt;
    AuthType Basic
    AuthName "Computer Networks"
    AuthUserFile DOCUMENT_ROOT/passwd
    Require user aptel
&lt;/Directory&gt;
</pre>
</li>
</ol>
<p>If you experience any problem try moving the directoy directive inside the Virtualhost 127.0.0.1:8181 directive</p>
<ol start="20">
<li>Create the directory <tt>DOCUMENT_ROOT/internal</tt> and copy the file <tt>aptel.html</tt> to it. What happens now when you try to access the URL <tt>http://your_machine:your_port/internal</tt> in a browser?</li>
<li>We will need to generate a password file (<tt>DOCUMENT_ROOT/passwd</tt>). To do so, we can use the <tt>htpasswd</tt> utility. Use <tt>htpasswd</tt> to create a file with a user <tt>aptel</tt> and password <tt>redes</tt>. Try entering with this user and password in a web browser.</li>
<li>Now try it using telnet. What is the name of the realm? Where does the server obtain it from? Send a second request to gain access to the page. You may use the converter to base64 that is available at <a href="http://www.webtoolkit.info/demo/javascript-base64">http://www.webtoolkit.info/demo/javascript-base64</a> (see input boxes below)</li>
<li>Change the configuration so that the authentication is of type "Digest" (you will also need to activate the corresponding Apache module). Check the reply with telnet. How does it differ? What should the client send back now? What advantages does "Digest" authentication have with respect to "Basic" authentication?</li>
</ol>
<h2>Optional part</h2>
<h3>Redirections and Virtual hosts</h3>
<p>The <b>Redirect</b> directive enables a client to be redirected from one URL to another.</p>
<ol start="24">
<li>
<p>Use this directive to specify that browsers that visit the URL <tt>http://your_machine:your_port/old/</tt> are automatically redirected to <tt>http://your_machine:your_port/new/</tt>.</p>
<p>The <b>&lt;VirtualHost&gt;</b> directive enables the web page sent by the server to depend on the name used to access it. This name is sent in the <tt>Host</tt> header of HTTP/1.1.</p>
</li>
<li>Create two new aptel.html pages (with the message Hello world vhost1, and with the message Hello world vhost2) and copy them to the virual hosts directories (look at the end of the httpd.conf file). Anwser the server with telnet and play with the host header!</li>
</ol></blockquote>