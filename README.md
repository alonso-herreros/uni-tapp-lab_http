[English version] (https://gitlab.pervasive.it.uc3m.es/aptel/http/blob/master/README_EN.md)

<h1>Aplicaciones Telemáticas: Servidores Web (HTTP)</h1>

<p></p>
<blockquote>
En esta práctica, configuraremos un servidor Web Apache version 2.X y probaremos su funcionamiento enviando peticiones HTTP y analizando las respuestas.
En el laboratorio tenemos un servidor apache instalado en el directorio /usr/sbin/. Por defecto, Apache obtiene la información de configuración del fichero <tt>/etc/apache2/apache2.conf</tt>. 
Nosotros, en cambio, utilizaremos nuestro propio fichero de configuración para probar distintas opciones y adaptarlo a nuestras necesidades.

En aula global disponéis de 2 ficheros que debéis descargar para la realización de la práctica (<tt>apache2.conf</tt> y <tt>mime.types</tt>). 
El primero (<tt>apache2.conf</tt>) contiene directivas necesarias para poder lanzar el servidor y directivas específicas relacionadas con el comportamiento.
El segundo fichero (<tt>mime.types</tt>) contiene la lista de tipos MIME relacionadas con el contenido que sirve el servidor. La estructura de este último fichero es muy sencilla: tipo/subtipo y la extensión asociada a dicho tipo.

<h3>Configuración del servidor</h3>
Antes de ejecutar el servidor, necesitamos modificar varias directivas. Para obtener información detallada sobre cualquiera de ellas, 
puedes consultar <a href="http://httpd.apache.org/docs/mod/directives.html">Directivas Apache</a>.
<p></p>
<ol>
<li>
<p>Prepara tu cuenta, descargando los archivos necesarios en ella y creando la siguiente estructura de directorios, donde <tt>d</tt> 
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
<li><strong><tt>ServerName</tt></strong></li>
<li><strong><tt>LockFile</tt></strong></li>
<li><strong><tt>PidFile</tt></strong></li>
<li><strong><tt>ScoreBoardFile</tt></strong></li>
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

<h3>Peticiones y respuestas HTTP</h3>
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


<h3>Procesos y recursos en el servidor web</h3>
<ol start="11">
<li>Mira cuántos procesos se están ejecutando. Para ello ejecuta el comando <tt>ps -x</tt>.

<p>Este número se puede controlar con la directiva <tt>StartServers</tt>. El servidor arranca inicialmente este número de procesos hijo para atender tráfico, 
aunque arranca y para dinámicamente nuevos procesos hijo según lo necesita (el número máximo se controla con la directiva <tt>MaxClients</tt>, 
ver también <tt>MinSpareServers</tt> y <tt>MaxSpareServers</tt>).</p>

<p>Modifica el fichero de configuración para que se arranquen por defecto 8 procesos hijo.</p>

<p><strong>Nota:</strong> Recuerda que los cambios en el servidor serán realizados una vez éste se reinicie. Para parar el servidor utiliza la opción <tt>-k stop</tt>
de <tt>/usr/sbin/apache2...</tt> o el comando <tt>kill</tt> junto con el número de proceso.
</li>
</ol>

<h3>Apache Logs</h3>
El servidor Apache genera unos registros ("log") interesantes sobre su funcionamiento. Por un lado, el registro de errores y por otro el registro de accesos.
<ol start="12">
<li>El registro de errores está en el fichero indicado por la directiva <b><tt>ErrorLog</tt></b>. 
Con la directiva <b><tt>LogLevel</tt></b> se puede variar el nivel de detalle del registro. 
Observa el fichero de registro de errores y aumenta el nivel de detalle a "debug", arranca de nuevo el servidor y comprueba cómo para el mismo tipo de peticiones
se almacena un mayor número de registros.</li>

<li>La directiva <b><tt>CustomLog</tt></b>  nos indica el fichero donde se va a guardar registro de los accesos a nuestro web. 
Examina el fichero de registro de accesos. Como ves, se identifica a las máquinas únicamente por su IP. 
Averigua qué directiva de <tt>apache.conf</tt> tienes que cambiar para conseguir que en el registro de accesos aparezca el nombre de la máquina ("hostname") 
en lugar de la IP. Haz el cambio y comprueba que funciona.</li>
</ol>

<h3>Tipos de contenido en Apache</h3>
Como habrás visto al hacer las consultas de las preguntas 7 y 8, el servidor nos dice el tipo MIME (Content-Type) del objeto que nos envía. 
Para saber el tipo MIME de un objeto, consulta la extensión del mismo en el fichero indicado en la directiva <tt>TypesConfig</tt>. 
<ol start="14">
<li>Añade que el fichero <tt>aptel.html</tt> sea el fichero que se envía por defecto y realiza las peticiones a <tt>http://your_machine:your_port/test.aptel</tt>
con un navegador y con telnet. ¿Cómo ves el fichero en el navegador? ¿cuál es el tipo MIME con él que se nos envía el fichero? ¿por qué?

</li>Cambia la configuración para que cuando la extensión sea "aptel" devuelva el tipo MIME  application/x-type-aptel. 
Comprueba que funciona correctamente ¿Qué hace ahora el navegador web? Prueba con varios navegadores, p.ej., Chrome y Firefox.</li>
</ol>

<h3>Gestión de Directorios y seguridad</h3>
Se puede cambiar la configuración para un directorio concreto mediante la directiva <Directory>. Por ejemplo, añade el siguiente código al final del fichero apache.conf (sustituyendo DOCUMENT_ROOT por el path completo del directorio adecuado de acuerdo a la configuración de tu servidor web):
<pre>
<Directory DOCUMENT_ROOT/internal>
    AuthType Basic
    AuthName "Computer Networks"
    AuthUserFile DOCUMENT_ROOT/passwd
    Require user aptel
</Directory>
</pre>
<ol start="16">
<li>Crea el directorio <tt>DocumentRoot/internal</tt> y copia en él el fichero <tt>aptel.html</tt>
¿Qué pasa ahora cuando intentas acceder con un navegador a la URL <tt>http://your_machine:your_port/internal</tt>?

<p><strong>Nota:</strong> puedes añadir un pequeño texto al fichero si lo quieres diferenciar.</p>
</li>

<li>Deberás generar el fichero de passwords (<tt>DocumentRoot/passwd</tt>), que se puede hacer con la utilidad <tt>htpasswd</tt>.
Crea con esta utilidad un fichero con un usuario <tt>aptel</tt> y contraseña <tt>redes</tt>. Prueba a entrar con este usuario y password usando un navegador web.
</li>

<li>Inténtalo ahora usando un telnet ¿Cuál es el nombre del reino? ¿De dónde lo obtiene el servidor? 
Manda una segunda petición para conseguir acceder a la página. Puedes usar el siguiente: <a href="https://www.base64encode.org/">conversor a base64</a>.</li>

<li>Cambia la configuración para que la autenticación sea de tipo "Digest" (necesitarás también habilitar el módulo correspondiente de Apache). 
Observa con un telnet cómo es la respuesta ¿En qué se diferencia? ¿qué enviaría ahora el cliente? ¿qué ventajas tiene frente a la autenticación "Basic"?

<p><strong>Nota:</strong> no hace falta que realice la petición con "Digest", simplemente que conozca cómo se hace.</p>
</li>
</ol>

<h3>Parte Opcional: Redirección y "Hosts" Virtuales</h3>
La directiva <b><tt>Redirect</tt></b> permite redireccionar a un cliente de una URL a otra. Para esta parte se requiere que modifique las directivas <li><strong><tt>within the VirtualHost directive</tt></strong> change : ServerAdmin, ServerName, ErrorLog, CustomLog</li>
<ol start="22">
<li>Usa esta directiva para hacer que los navegadores que visiten la URL <tt>http://your_machine:your_port/old/</tt>
sean automáticamente redirigidos a <tt>http://your_machine:your_port/new/</tt>.</li>

<p>La directiva <b>&lt;VirtualHost&gt;</b> permite hacer que el servidor responda distintas páginas web, 
según el nombre de servidor que utilicemos para acceder a él. Este nombre se le envía con la cabecera Host de HTTP/1.1.</p>
</li>

<li>Crea dos nuevas páginas <tt>aptel.html</tt> (con mensajes “¡Hola mundo vhost1!”, y “¡Hola mundo vhost2!”, respectivamente) y 
cópialas a los directorios virtual hosts (al final del fichero <tt>apache2.conf</tt>). Haz pruebas enviando peticiones telnet cambiando la cabecera host.
</li>
</ol>
</blockquote>
