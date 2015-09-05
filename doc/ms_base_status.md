

# Module ms_base_status #
* [Function Index](#index)
* [Function Details](#functions)

__Behaviours:__ [`cowboy_http_handler`](cowboy_http_handler.md).

<a name="index"></a>

## Function Index ##


<table width="100%" border="1" cellspacing="0" cellpadding="2" summary="function index"><tr><td valign="top"><a href="#handle-2">handle/2</a></td><td></td></tr><tr><td valign="top"><a href="#init-3">init/3</a></td><td></td></tr><tr><td valign="top"><a href="#terminate-3">terminate/3</a></td><td></td></tr></table>


<a name="functions"></a>

## Function Details ##

<a name="handle-2"></a>

### handle/2 ###

<pre><code>
handle(Req::<a href="cowboy_req.md#type-req">cowboy_req:req()</a>, X2::undefined) -&gt; {ok, <a href="cowboy_req.md#type-req">cowboy_req:req()</a>, undefined}
</code></pre>
<br />

<a name="init-3"></a>

### init/3 ###

<pre><code>
init(X1::{tcp, http}, Req::<a href="cowboy_req.md#type-req">cowboy_req:req()</a>, X3::[]) -&gt; {ok, <a href="cowboy_req.md#type-req">cowboy_req:req()</a>, undefined}
</code></pre>
<br />

<a name="terminate-3"></a>

### terminate/3 ###

<pre><code>
terminate(Reason::term(), Req::<a href="cowboy_req.md#type-req">cowboy_req:req()</a>, X3::undefined) -&gt; ok
</code></pre>
<br />

