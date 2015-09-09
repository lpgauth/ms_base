

# Module ms_base #
* [Function Index](#index)
* [Function Details](#functions)

<a name="index"></a>

## Function Index ##


<table width="100%" border="1" cellspacing="0" cellpadding="2" summary="function index"><tr><td valign="top"><a href="#apply-4">apply/4</a></td><td></td></tr><tr><td valign="top"><a href="#apply_all-4">apply_all/4</a></td><td></td></tr><tr><td valign="top"><a href="#apply_all_not_local-4">apply_all_not_local/4</a></td><td></td></tr><tr><td valign="top"><a href="#apply_hash-5">apply_hash/5</a></td><td></td></tr></table>


<a name="functions"></a>

## Function Details ##

<a name="apply-4"></a>

### apply/4 ###

<pre><code>
apply(Type::atom(), Module::module(), Function::atom(), Args::[term()]) -&gt; term() | {error, no_node} | {badrpc, term()}
</code></pre>
<br />

<a name="apply_all-4"></a>

### apply_all/4 ###

<pre><code>
apply_all(Type::atom(), Module::module(), Function::atom(), Args::[term()]) -&gt; [term()]
</code></pre>
<br />

<a name="apply_all_not_local-4"></a>

### apply_all_not_local/4 ###

<pre><code>
apply_all_not_local(Type::atom(), Module::module(), Function::atom(), Args::[term()]) -&gt; [term()]
</code></pre>
<br />

<a name="apply_hash-5"></a>

### apply_hash/5 ###

<pre><code>
apply_hash(Type::atom(), Term::term(), Module::module(), Function::atom(), Args::[term()]) -&gt; term() | {error, no_node} | {badrpc, term()}
</code></pre>
<br />

