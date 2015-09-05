

# Module ms_base_global #
* [Function Index](#index)
* [Function Details](#functions)

<a name="index"></a>

## Function Index ##


<table width="100%" border="1" cellspacing="0" cellpadding="2" summary="function index"><tr><td valign="top"><a href="#lookup-1">lookup/1</a></td><td></td></tr><tr><td valign="top"><a href="#register-2">register/2</a></td><td></td></tr><tr><td valign="top"><a href="#start-0">start/0</a></td><td></td></tr><tr><td valign="top"><a href="#stop-0">stop/0</a></td><td></td></tr><tr><td valign="top"><a href="#unregister-1">unregister/1</a></td><td></td></tr></table>


<a name="functions"></a>

## Function Details ##

<a name="lookup-1"></a>

### lookup/1 ###

<pre><code>
lookup(Name::atom()) -&gt; term() | undefined
</code></pre>
<br />

<a name="register-2"></a>

### register/2 ###

<pre><code>
register(Name::atom(), Object::term()) -&gt; ok | registered_name
</code></pre>
<br />

<a name="start-0"></a>

### start/0 ###

<pre><code>
start() -&gt; ok
</code></pre>
<br />

<a name="stop-0"></a>

### stop/0 ###

<pre><code>
stop() -&gt; ok
</code></pre>
<br />

<a name="unregister-1"></a>

### unregister/1 ###

<pre><code>
unregister(Name::atom()) -&gt; ok
</code></pre>
<br />

