[English version] (https://gitlab.pervasive.it.uc3m.es/aptel/http/blob/master/README_EN.md)

Apache Logs
El servidor Apache genera unos registros ("log") interesantes sobre su funcionamiento. Por un lado, el registro de errores y por otro el registro de accesos.
14.	El registro de errores está en el fichero indicado por la directiva ErrorLog. Con la directiva LogLevel se puede variar el nivel de detalle del registro. Observa el fichero de registro de errores y aumenta el nivel de detalle a "debug", arranca de nuevo el servidor y comprueba cómo para el mismo tipo de peticiones se almacena un mayor número de registros.
15.	La directiva CustomLog nos indica el fichero donde se va a guardar registro de los accesos a nuestro web. Examina el fichero de registro de accesos. Como ves, se identifica a las máquinas únicamente por su IP. Averigua qué directiva de apache.conf tienes que cambiar para conseguir que en el registro de accesos aparezca el nombre de la máquina ("hostname") en lugar de la IP. Haz el cambio y comprueba que funciona.
Content Types en Apache
Como habrás visto al hacer las consultas de las preguntas 7 y 8, el servidor nos dice el tipo MIME (Content-Type) del objeto que nos envía. Para saber el tipo MIME de un objeto, consulta la extensión del mismo en el fichero indicado en la directiva TypesConfig. 
16.	Copia el fichero aptel.html a test.aptel y realiza las peticiones http://your_machine:your_port/test.aptel con un navegador y con telnet. ¿Cómo ves el fichero en el navegador? ¿cuál es el tipo MIME con él que se nos envía el fichero? ¿por qué?
17.	Cambia la configuración para que cuando la extensión sea aptel devuelva el tipo MIME  application/x-type-aptel. Comprueba que funciona correctamente. ¿Qué hace ahora el navegador web? Prueba con varios navegadores, p.ej. Chrome y Firefox.

Gestión de Directorios y seguridad
Se puede cambiar la configuración para un directorio concreto mediante la directiva <Directory>. Por ejemplo, añade el siguiente código al final del fichero apache.conf (sustituyendo DOCUMENT_ROOT por el path completo del directorio adecuado de acuerdo a la configuración de tu servidor web):
<Directory DOCUMENT_ROOT/internal>
    AuthType Basic
    AuthName "Computer Networks"
    AuthUserFile DOCUMENT_ROOT/passwd
    Require user aptel
</Directory>
18.	Crea el directorio internal dentro de la ruta configurada en la directiva DocumentRoot y copia en él el fichero aptel.html. ¿Qué pasa ahora cuando intentas acceder con un navegador a la URL http://su_maquina:su_puerto/internal/aptel.html? Nota: puedes añadir un pequeño texto al fichero si lo quieres diferenciar.
19.	Deberás generar el fichero de passwords (DOCUMENT_ROOT/passwd), que se puede hacer con la utilidad htpasswd. Crea con esta utilidad un fichero con un usuario aptel y password redes. Prueba a entrar con este usuario y password usando un navegador web.
20.	Inténtalo ahora usando un telnet. ¿Cuál es el nombre del reino? ¿De dónde lo obtiene el servidor? Manda una segunda petición para conseguir acceder a la página. Puedes usar el conversor a base64 https://www.base64encode.org/ .
21.	Cambia la configuración para que la autenticación sea de tipo Digest (necesitarás también habilitar el módulo correspondiente de Apache). Observa con un telnet cómo es la respuesta. ¿En qué se diferencia? ¿qué enviaría ahora el cliente? ¿qué ventajas tiene frente a la autenticación "Basic"?


<h1>Aplicaciones Telemáticas: Servidores Web (HTTP)</h1>
<p></p>
<blockquote>
En esta práctica, configuraremos un servidor Web Apache version 2.X y probaremos su funcionamiento enviando peticiones HTTP y analizando las respuestas.
En el laboratorio tenemos un servidor apache instalado en el directorio /usr/sbin/. Por defecto, Apache obtiene la información de configuración del fichero <tt>/etc/apache2/apache2.conf</tt>. 
Nosotros, en cambio, utilizaremos nuestro propio fichero de configuración para probar distintas opciones y adaptarlo a nuestras necesidades.

En aula global disponéis de 2 ficheros que debéis descargar para la realización de la práctica (<tt>apache2.conf</tt> y <tt>mime.types</tt>). 
El primero (<tt>apache2.conf</tt>) contiene directivas necesarias para poder lanzar el servidor y directivas específicas relacionadas con el comportamiento.
El segundo fichero (<tt>mime.types</tt>) contiene la lista de tipos MIME relacionadas con el contenido que sirve el servidor. La estructura de este último fichero es muy sencilla: tipo/subtipo y la extensión asociada a dicho tipo.

# Configuración del servidor
Antes de ejecutar el servidor, necesitamos modificar varias directivas. Para obtener información detallada sobre cualquiera de ellas, 
puedes consultar <a href="http://httpd.apache.org/docs/mod/directives.html">Directivas Apache</a>.
<p></p>
<ol>
<li>
<p>Preparación de la cuenta. Descarga todos los archivos necesarios en tu cuenta y crea la siguiente estructura de directorios, donde <tt>d</tt> 
indica que se trata de un directorio o carpeta y <tt>f</tt> de un fichero:</p>
<pre>d-httpd                    (directorio raíz del servidor "<tt>ServerRoot</tt>")
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
</li>
<li>A continuación, modificaremos ciertas directivas para que apunten a ficheros en nuestra cuenta y para determinar ciertos parámetros de ejecución:
<ul>
<li>Abre <tt>apache2.conf</tt> y cambia:
<ul>
<li><b>ServerRoot</b>: ruta al directorio en el que se encuentran los ficheros de configuración necesarios para la correcta operación del servidor 
(ruta absoluta al directorio <tt>httpd</tt> de vuestra cuenta).</li>
<li><strong><tt>DocumentRoot</tt></strong>: apuntará a la ruta de la carpeta en la que se almacenan los documentos que servirá el servidor (<tt>defaultdocs</tt>). Si no empieza por "/" esta ruta será relativa a la indicada en <tt>"ServerRoot"</tt>, por tanto, podría únicamente indicar <tt>defaultdocs</tt>.</li>
<li><strong><tt>LockFile</tt></strong></li>
<li><strong><tt>PidFile</tt></strong></li>
<li><strong><tt>ScoreBoardFile</tt></strong></li>
<li><strong><tt>User</tt></strong></li>
<li><strong><tt>Listen</tt></strong></li>
<li><strong><tt>ErrorLog</tt></strong></li>
<li><strong><tt>CustomLog</tt></strong></li>
<li><strong><tt>TypesConfig</tt></strong>: indicando la ruta donde se almacena <tt>mime.types</tt> en vuesta cuenta.</li>
</ul>
<p><strong>Nota:</strong> Se recomienda indicar una <strong>ruta absoluta</strong> en <tt>ServerRoot</tt> y rutas o nombres de ficheros <strong>relativos</strong> en el resto de directivas.</p>
</li>

<li>Crea una página web sencilla <tt>aptel.html</tt> en <tt>httpd/defaultdocs</tt>, por ejemplo:
<pre>
<html>
<head>
 <title>Página de inicio Aptel</title>
</head>
<body>
¡Hola mundo!
</body>
</html>
</pre>
</li>

<li>Ahora podemos <span style="font-weight: bold;">arrancar nuestro servidor</span> indicando el fichero de configuración que hemos adaptado. Se hace con el comando: 
<pre>/usr/sbin/apache2 -f $PATH_COMPLETO/apache2.conf -t</pre>

<p>Verifica que el servidor se está ejecutando: usando el comando <tt>ps</tt> o bien abriendo el fichero <tt>apache2.pid</tt>
(si este fichero no existe, es porque el servidor no está ejecutando-- revisa los logs para detectar el problema).</p>
</li>

<li>Accede a la página recién creada (aptel.html) a través del navegador en la URL <tt>http://servername:port/aptel.html</tt>.
Intenta acceder también usando simplemente <tt>http://servername:port/</tt>. 

<p>Tenga en cuenta que si no especificamos la página HTML que queremos acceder, el servidor puede actuar de dos maneras: </p>
<ul>
<li>Mostrando un listado de los directorios (no recomendable), o</li>
<li>Mostrando un fichero HTML por defecto. 
</li>
</ul>

<p>Para obtener el segundo comportamiento, se usa la directiva <b><tt>DirectoryIndex</tt></b>  para especificar el nombre del fichero por defecto. 
Verifique que esta directiva ya está definida y, por lo general, es <tt>index.html</tt>. De momento, no modifique esta directiva. </p>

<p><strong>Nota:</strong> Si hay un error, investiga qué ocurre accediendo al fichero configurado en la directiva <tt>ErrorLog</tt></p>.
</li>
</ol>

## Peticiones y respuestas HTTP
Una vez que hemos comprobado el funcionamiento de nuestro servidor utilizando el navegador como cliente, vamos a utilizar un cliente <tt>telnet</tt>.

<ol start="7">
<li>Haz las peticiones realizadas anteriormente con el navegador <tt>http://your_machine:your_port/aptel.html</tt>? y
<tt>http://your_machine:your_port/</tt> usando <tt>telnet</tt><. Envía peticiones usando HTTP/0.9 y HTTP/1.0 ¿Qué respuestas y qué cabeceras obtiene?/li>

<li>Repite las peticiones usando HTTP/1.1 ¿Qué cabecera debes incluir en la petición? ¿cierra el servidor la conexión inmediatamente? 
¿qué se debe incluir en la petición para que lo haga? Pruébalo.</li>

<li>Aún si no manda nada en la petición HTTP/1.1 para que cierre la conexión de forma inmediata, el servidor lo hace tras un tiempo de inactividad. 
Mide cuánto es este tiempo y comprueba que coincide con el que viene especificado en la directiva <b><tt>KeepAliveTimeout</tt></b>.</li>

<li>Mira el fichero <tt>apache2.conf</tt> y explica para qué sirven las directivas <b><tt>KeepAlive</tt></b> y <b><tt>MaxKeepAliveRequests</tt></b>.</li>
</ol>



Procesos y recursos en el servidor web
11.	Mira cuántos procesos se están ejecutando. Para ello ejecuta el comando ps x. Este número se puede controlar con la directiva StartServers. El servidor arranca inicialmente este número de procesos hijo para atender tráfico, aunque arranca y para dinámicamente nuevos procesos hijo según lo necesita (el número máximo se controla con la directiva MaxClients, ver también MinSpareServers y MaxSpareServers).
12.	Modifica el fichero apache2.conf para que se arranquen por defecto 8 procesos hijo. 
13.	Añade que el fichero aptel.html sea el fichero que se envía por defecto. Puedes también, si así lo deseas, cambiar el valor de otras directivas que se han comentado en los apartados anteriores.


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
<li><strong><tt>within the VirtualHost directive</tt></strong> change : ServerAdmin, ServerName, ErrorLog, CustomLog</li>
<p>The <b>Redirect</b> directive enables a client to be redirected from one URL to another.</p>
<ol start="24">
<li>
<p>Use this directive to specify that browsers that visit the URL <tt>http://your_machine:your_port/old/</tt> are automatically redirected to <tt>http://your_machine:your_port/new/</tt>.</p>
<p>The <b>&lt;VirtualHost&gt;</b> directive enables the web page sent by the server to depend on the name used to access it. This name is sent in the <tt>Host</tt> header of HTTP/1.1.</p>
</li>
<li>Create two new aptel.html pages (with the message Hello world vhost1, and with the message Hello world vhost2) and copy them to the virual hosts directories (look at the end of the httpd.conf file). Anwser the server with telnet and play with the host header!</li>
</ol></blockquote>

Parte Opcional: Redirecciones y Hosts Virtuales
La directiva Redirect permite redireccionar a un cliente de una URL a otra.
22.	Usa esta directiva para hacer que los navegadores que visiten la URL http://your_machine:your_port/old/ sean automáticamente redirigidos a http://your_machine:your_port/new/.
La directiva <VirtualHost> permite hacer que el servidor responda distintas páginas web, según el nombre de servidor que utilicemos para acceder a él. Este nombre se le envía con la cabecera Host de HTTP/1.1.
23.	Crea dos nuevas páginas aptel.html (con mensajes “Hello world vhost1”, y “Hello world vhost2”, respectivamente) y cópialas a los directorios virtual hosts (al final del fichero apache2.conf). Haz pruebas enviando peticiones telnet cambiando la cabecera host.

