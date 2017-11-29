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
<li>If everithing is correct, execute:
 <li>Even if you do not send anything in the HTTP/1.1 request to tell the server to close the connection immediately, it still does so after a certain length of time if there is no activity. Measure this time. Check that it coincides with the specified <b>KeepAliveTimeout</b> directive.</li>
 <li>Check again the <tt>apache2.conf (or httpd-default.conf)</tt> file and see what <b>KeepAlive</b> and <b>MaxKeepAliveRequests</b> directives are for.</li>
 </ol>
 <h3>Processes and resources in the web server</h3>
 
 ## Processes and resources in the web server
 <ol start="11">
 <li>
 <p>Use the <tt>ps -x</tt> command to find out how many server processes are executing (piping the output to a grep will make the visualization easier). This number can be controlled with the <b>StartServers</b> directive. The server initially starts this number of child processes to service requests, though it also dynamically starts and stops new child processes as needed (the maximum number is controlled with the <b>MaxClients</b> directive; see also <b>MinSpareServers</b> y <b>MaxSpareServers</b>, all in <tt>apache2.conf or httpd-mpm.conf</tt> file).</p>
@@ -110,7 +111,8 @@ If everithing is correct, execute:
 <li>Copy the file <tt>aptel.html</tt> to <tt>test.aptel</tt> and issue the request <tt>http://your_machine:your_port/test.aptel</tt> with a browser and with telnet. How is the file presented in the browser? What MIME type is the file sent with? Why?</li>
 <li>Change the configuration (in mime.types --add a line) so that when the extension is <tt>aptel</tt> the MIME type is set to <tt>application/x-type-aptel</tt>. Check that it works correctly. What does the web browser do now?</li>
 </ol>
 <h3>Directory management and security</h3>
 
 ## Directory management and security
 <p>The configuration can be changed for a given directory using the <b>&lt;Directory&gt;</b> directive. for example, add the following code at the end of the <tt>httpd.conf</tt> file (substituting <tt>DOCUMENT_ROOT</tt> for the full path of the root directory of your web site):</p>
 <ol start="19">
 <li>
@@ -120,20+120,20 @@
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
 
 
 ## Optional part
 ### Redirections and Virtual hosts
 <p>The <b>Redirect</b> directive enables a client to be redirected from one URL to another.</p>
 <ol start="24">
 <li>
 <p>Use this directive to specify that browsers that visit the URL <tt>http://your_machine:your_port/old/</tt> are automatically redirected to <tt>http://your_machine:your_port/new/</tt>.</p>
 <p>The <b>&lt;VirtualHost&gt;</b> directive enables the web page sent by the server to depend on the name used to access it. This name is sent in the <tt>Host</tt> header of HTTP/1.1.</p>
 </li>
 <li>Create two new aptel.html pages (with the message Hello world vhost1, and with the message Hello world vhost2) and copy them to the virual hosts directories (look at the end of the httpd.conf file). Anwser the server with telnet and play with the host header!</li>
</ol>