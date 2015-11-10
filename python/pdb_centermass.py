



<!DOCTYPE html>
<html>
<head>
 <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" >
 <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" >
 
 <meta name="ROBOTS" content="NOARCHIVE">
 
 <link rel="icon" type="image/vnd.microsoft.icon" href="http://www.gstatic.com/codesite/ph/images/phosting.ico">
 
 
 <script type="text/javascript">
 
 
 
 
 var codesite_token = null;
 
 
 var CS_env = {"assetVersionPath":"http://www.gstatic.com/codesite/ph/10432160532581480325","assetHostPath":"http://www.gstatic.com/codesite/ph","loggedInUserEmail":null,"relativeBaseUrl":"","projectName":"pdb-tools","domainName":null,"profileUrl":null,"token":null,"projectHomeUrl":"/p/pdb-tools"};
 var _gaq = _gaq || [];
 _gaq.push(
 ['siteTracker._setAccount', 'UA-18071-1'],
 ['siteTracker._trackPageview']);
 
 _gaq.push(
 ['projectTracker._setAccount', 'UA-3669756-1'],
 ['projectTracker._trackPageview']);
 
 (function() {
 var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
 ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
 (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(ga);
 })();
 
 </script>
 
 
 <title>pdb_centermass.py - 
 pdb-tools -
 
 
 A set of tools for manipulating and doing calculations on wwPDB macromolecule structure files - Google Project Hosting
 </title>
 <link type="text/css" rel="stylesheet" href="http://www.gstatic.com/codesite/ph/10432160532581480325/css/core.css">
 
 <link type="text/css" rel="stylesheet" href="http://www.gstatic.com/codesite/ph/10432160532581480325/css/ph_detail.css" >
 
 
 <link type="text/css" rel="stylesheet" href="http://www.gstatic.com/codesite/ph/10432160532581480325/css/d_sb.css" >
 
 
 
<!--[if IE]>
 <link type="text/css" rel="stylesheet" href="http://www.gstatic.com/codesite/ph/10432160532581480325/css/d_ie.css" >
<![endif]-->
 <style type="text/css">
 .menuIcon.off { background: no-repeat url(http://www.gstatic.com/codesite/ph/images/dropdown_sprite.gif) 0 -42px }
 .menuIcon.on { background: no-repeat url(http://www.gstatic.com/codesite/ph/images/dropdown_sprite.gif) 0 -28px }
 .menuIcon.down { background: no-repeat url(http://www.gstatic.com/codesite/ph/images/dropdown_sprite.gif) 0 0; }
 
 
 
  tr.inline_comment {
 background: #fff;
 vertical-align: top;
 }
 div.draft, div.published {
 padding: .3em;
 border: 1px solid #999; 
 margin-bottom: .1em;
 font-family: arial, sans-serif;
 max-width: 60em;
 }
 div.draft {
 background: #ffa;
 } 
 div.published {
 background: #e5ecf9;
 }
 div.published .body, div.draft .body {
 padding: .5em .1em .1em .1em;
 max-width: 60em;
 white-space: pre-wrap;
 white-space: -moz-pre-wrap;
 white-space: -pre-wrap;
 white-space: -o-pre-wrap;
 word-wrap: break-word;
 font-size: 1em;
 }
 div.draft .actions {
 margin-left: 1em;
 font-size: 90%;
 }
 div.draft form {
 padding: .5em .5em .5em 0;
 }
 div.draft textarea, div.published textarea {
 width: 95%;
 height: 10em;
 font-family: arial, sans-serif;
 margin-bottom: .5em;
 }

 
 .nocursor, .nocursor td, .cursor_hidden, .cursor_hidden td {
 background-color: white;
 height: 2px;
 }
 .cursor, .cursor td {
 background-color: darkblue;
 height: 2px;
 display: '';
 }
 
 
.list {
 border: 1px solid white;
 border-bottom: 0;
}

 
 </style>
</head>
<body class="t4">
<script type="text/javascript">
 window.___gcfg = {lang: 'en'};
 (function() 
 {var po = document.createElement("script");
 po.type = "text/javascript"; po.async = true;po.src = "https://apis.google.com/js/plusone.js";
 var s = document.getElementsByTagName("script")[0];
 s.parentNode.insertBefore(po, s);
 })();
</script>
<div class="headbg">

 <div id="gaia">
 

 <span>
 
 
 <a href="#" id="projects-dropdown" onclick="return false;"><u>My favorites</u> <small>&#9660;</small></a>
 | <a href="https://www.google.com/accounts/ServiceLogin?service=code&amp;ltmpl=phosting&amp;continue=http%3A%2F%2Fcode.google.com%2Fp%2Fpdb-tools%2Fsource%2Fbrowse%2Ftrunk%2FpdbTools%2Fpdb_centermass.py&amp;followup=http%3A%2F%2Fcode.google.com%2Fp%2Fpdb-tools%2Fsource%2Fbrowse%2Ftrunk%2FpdbTools%2Fpdb_centermass.py" onclick="_CS_click('/gb/ph/signin');"><u>Sign in</u></a>
 
 </span>

 </div>

 <div class="gbh" style="left: 0pt;"></div>
 <div class="gbh" style="right: 0pt;"></div>
 
 
 <div style="height: 1px"></div>
<!--[if lte IE 7]>
<div style="text-align:center;">
Your version of Internet Explorer is not supported. Try a browser that
contributes to open source, such as <a href="http://www.firefox.com">Firefox</a>,
<a href="http://www.google.com/chrome">Google Chrome</a>, or
<a href="http://code.google.com/chrome/chromeframe/">Google Chrome Frame</a>.
</div>
<![endif]-->



 <table style="padding:0px; margin: 0px 0px 10px 0px; width:100%" cellpadding="0" cellspacing="0"
 itemscope itemtype="http://schema.org/CreativeWork">
 <tr style="height: 58px;">
 
 
 
 <td id="plogo">
 <link itemprop="url" href="/p/pdb-tools">
 <a href="/p/pdb-tools/">
 
 <img src="http://www.gstatic.com/codesite/ph/images/defaultlogo.png" alt="Logo" itemprop="image">
 
 </a>
 </td>
 
 <td style="padding-left: 0.5em">
 
 <div id="pname">
 <a href="/p/pdb-tools/"><span itemprop="name">pdb-tools</span></a>
 </div>
 
 <div id="psum">
 <a id="project_summary_link"
 href="/p/pdb-tools/"><span itemprop="description">A set of tools for manipulating and doing calculations on wwPDB macromolecule structure files</span></a>
 
 </div>
 
 
 </td>
 <td style="white-space:nowrap;text-align:right; vertical-align:bottom;">
 
 <form action="/hosting/search">
 <input size="30" name="q" value="" type="text">
 
 <input type="submit" name="projectsearch" value="Search projects" >
 </form>
 
 </tr>
 </table>

</div>

 
<div id="mt" class="gtb"> 
 <a href="/p/pdb-tools/" class="tab ">Project&nbsp;Home</a>
 
 
 
 
 <a href="/p/pdb-tools/downloads/list" class="tab ">Downloads</a>
 
 
 
 
 
 <a href="/p/pdb-tools/w/list" class="tab ">Wiki</a>
 
 
 
 
 
 <a href="/p/pdb-tools/issues/list"
 class="tab ">Issues</a>
 
 
 
 
 
 <a href="/p/pdb-tools/source/checkout"
 class="tab active">Source</a>
 
 
 
 
 
 
 
 
 <div class=gtbc></div>
</div>
<table cellspacing="0" cellpadding="0" width="100%" align="center" border="0" class="st">
 <tr>
 
 
 
 
 
 
 <td class="subt">
 <div class="st2">
 <div class="isf">
 
 


 <span class="inst1"><a href="/p/pdb-tools/source/checkout">Checkout</a></span> &nbsp;
 <span class="inst2"><a href="/p/pdb-tools/source/browse/">Browse</a></span> &nbsp;
 <span class="inst3"><a href="/p/pdb-tools/source/list">Changes</a></span> &nbsp;
 
 &nbsp;
 
 
 <form action="/p/pdb-tools/source/search" method="get" style="display:inline"
 onsubmit="document.getElementById('codesearchq').value = document.getElementById('origq').value">
 <input type="hidden" name="q" id="codesearchq" value="">
 <input type="text" maxlength="2048" size="38" id="origq" name="origq" value="" title="Google Code Search" style="font-size:92%">&nbsp;<input type="submit" value="Search Trunk" name="btnG" style="font-size:92%">
 
 
 
 
 
 
 </form>
 <script type="text/javascript">
 
 function codesearchQuery(form) {
 var query = document.getElementById('q').value;
 if (query) { form.action += '%20' + query; }
 }
 </script>
 </div>
</div>

 </td>
 
 
 
 <td align="right" valign="top" class="bevel-right"></td>
 </tr>
</table>


<script type="text/javascript">
 var cancelBubble = false;
 function _go(url) { document.location = url; }
</script>
<div id="maincol"
 
>

 




<div class="expand">
<div id="colcontrol">
<style type="text/css">
 #file_flipper { white-space: nowrap; padding-right: 2em; }
 #file_flipper.hidden { display: none; }
 #file_flipper .pagelink { color: #0000CC; text-decoration: underline; }
 #file_flipper #visiblefiles { padding-left: 0.5em; padding-right: 0.5em; }
</style>
<table id="nav_and_rev" class="list"
 cellpadding="0" cellspacing="0" width="100%">
 <tr>
 
 <td nowrap="nowrap" class="src_crumbs src_nav" width="33%">
 <strong class="src_nav">Source path:&nbsp;</strong>
 <span id="crumb_root">
 
 <a href="/p/pdb-tools/source/browse/">svn</a>/&nbsp;</span>
 <span id="crumb_links" class="ifClosed"><a href="/p/pdb-tools/source/browse/trunk/">trunk</a><span class="sp">/&nbsp;</span><a href="/p/pdb-tools/source/browse/trunk/pdbTools/">pdbTools</a><span class="sp">/&nbsp;</span>pdb_centermass.py</span>
 
 


 </td>
 
 
 <td nowrap="nowrap" width="33%" align="right">
 <table cellpadding="0" cellspacing="0" style="font-size: 100%"><tr>
 
 
 <td class="flipper">
 <ul class="leftside">
 
 <li><a href="/p/pdb-tools/source/browse/trunk/pdbTools/pdb_centermass.py?r=56" title="Previous">&lsaquo;r56</a></li>
 
 </ul>
 </td>
 
 <td class="flipper"><b>r62</b></td>
 
 </tr></table>
 </td> 
 </tr>
</table>

<div class="fc">
 
 
 
<style type="text/css">
.undermouse span {
 background-image: url(http://www.gstatic.com/codesite/ph/images/comments.gif); }
</style>
<table class="opened" id="review_comment_area"
><tr>
<td id="nums">
<pre><table width="100%"><tr class="nocursor"><td></td></tr></table></pre>
<pre><table width="100%" id="nums_table_0"><tr id="gr_svn62_1"

><td id="1"><a href="#1">1</a></td></tr
><tr id="gr_svn62_2"

><td id="2"><a href="#2">2</a></td></tr
><tr id="gr_svn62_3"

><td id="3"><a href="#3">3</a></td></tr
><tr id="gr_svn62_4"

><td id="4"><a href="#4">4</a></td></tr
><tr id="gr_svn62_5"

><td id="5"><a href="#5">5</a></td></tr
><tr id="gr_svn62_6"

><td id="6"><a href="#6">6</a></td></tr
><tr id="gr_svn62_7"

><td id="7"><a href="#7">7</a></td></tr
><tr id="gr_svn62_8"

><td id="8"><a href="#8">8</a></td></tr
><tr id="gr_svn62_9"

><td id="9"><a href="#9">9</a></td></tr
><tr id="gr_svn62_10"

><td id="10"><a href="#10">10</a></td></tr
><tr id="gr_svn62_11"

><td id="11"><a href="#11">11</a></td></tr
><tr id="gr_svn62_12"

><td id="12"><a href="#12">12</a></td></tr
><tr id="gr_svn62_13"

><td id="13"><a href="#13">13</a></td></tr
><tr id="gr_svn62_14"

><td id="14"><a href="#14">14</a></td></tr
><tr id="gr_svn62_15"

><td id="15"><a href="#15">15</a></td></tr
><tr id="gr_svn62_16"

><td id="16"><a href="#16">16</a></td></tr
><tr id="gr_svn62_17"

><td id="17"><a href="#17">17</a></td></tr
><tr id="gr_svn62_18"

><td id="18"><a href="#18">18</a></td></tr
><tr id="gr_svn62_19"

><td id="19"><a href="#19">19</a></td></tr
><tr id="gr_svn62_20"

><td id="20"><a href="#20">20</a></td></tr
><tr id="gr_svn62_21"

><td id="21"><a href="#21">21</a></td></tr
><tr id="gr_svn62_22"

><td id="22"><a href="#22">22</a></td></tr
><tr id="gr_svn62_23"

><td id="23"><a href="#23">23</a></td></tr
><tr id="gr_svn62_24"

><td id="24"><a href="#24">24</a></td></tr
><tr id="gr_svn62_25"

><td id="25"><a href="#25">25</a></td></tr
><tr id="gr_svn62_26"

><td id="26"><a href="#26">26</a></td></tr
><tr id="gr_svn62_27"

><td id="27"><a href="#27">27</a></td></tr
><tr id="gr_svn62_28"

><td id="28"><a href="#28">28</a></td></tr
><tr id="gr_svn62_29"

><td id="29"><a href="#29">29</a></td></tr
><tr id="gr_svn62_30"

><td id="30"><a href="#30">30</a></td></tr
><tr id="gr_svn62_31"

><td id="31"><a href="#31">31</a></td></tr
><tr id="gr_svn62_32"

><td id="32"><a href="#32">32</a></td></tr
><tr id="gr_svn62_33"

><td id="33"><a href="#33">33</a></td></tr
><tr id="gr_svn62_34"

><td id="34"><a href="#34">34</a></td></tr
><tr id="gr_svn62_35"

><td id="35"><a href="#35">35</a></td></tr
><tr id="gr_svn62_36"

><td id="36"><a href="#36">36</a></td></tr
><tr id="gr_svn62_37"

><td id="37"><a href="#37">37</a></td></tr
><tr id="gr_svn62_38"

><td id="38"><a href="#38">38</a></td></tr
><tr id="gr_svn62_39"

><td id="39"><a href="#39">39</a></td></tr
><tr id="gr_svn62_40"

><td id="40"><a href="#40">40</a></td></tr
><tr id="gr_svn62_41"

><td id="41"><a href="#41">41</a></td></tr
><tr id="gr_svn62_42"

><td id="42"><a href="#42">42</a></td></tr
><tr id="gr_svn62_43"

><td id="43"><a href="#43">43</a></td></tr
><tr id="gr_svn62_44"

><td id="44"><a href="#44">44</a></td></tr
><tr id="gr_svn62_45"

><td id="45"><a href="#45">45</a></td></tr
><tr id="gr_svn62_46"

><td id="46"><a href="#46">46</a></td></tr
><tr id="gr_svn62_47"

><td id="47"><a href="#47">47</a></td></tr
><tr id="gr_svn62_48"

><td id="48"><a href="#48">48</a></td></tr
><tr id="gr_svn62_49"

><td id="49"><a href="#49">49</a></td></tr
><tr id="gr_svn62_50"

><td id="50"><a href="#50">50</a></td></tr
><tr id="gr_svn62_51"

><td id="51"><a href="#51">51</a></td></tr
><tr id="gr_svn62_52"

><td id="52"><a href="#52">52</a></td></tr
><tr id="gr_svn62_53"

><td id="53"><a href="#53">53</a></td></tr
><tr id="gr_svn62_54"

><td id="54"><a href="#54">54</a></td></tr
><tr id="gr_svn62_55"

><td id="55"><a href="#55">55</a></td></tr
><tr id="gr_svn62_56"

><td id="56"><a href="#56">56</a></td></tr
><tr id="gr_svn62_57"

><td id="57"><a href="#57">57</a></td></tr
><tr id="gr_svn62_58"

><td id="58"><a href="#58">58</a></td></tr
><tr id="gr_svn62_59"

><td id="59"><a href="#59">59</a></td></tr
><tr id="gr_svn62_60"

><td id="60"><a href="#60">60</a></td></tr
><tr id="gr_svn62_61"

><td id="61"><a href="#61">61</a></td></tr
><tr id="gr_svn62_62"

><td id="62"><a href="#62">62</a></td></tr
><tr id="gr_svn62_63"

><td id="63"><a href="#63">63</a></td></tr
><tr id="gr_svn62_64"

><td id="64"><a href="#64">64</a></td></tr
><tr id="gr_svn62_65"

><td id="65"><a href="#65">65</a></td></tr
><tr id="gr_svn62_66"

><td id="66"><a href="#66">66</a></td></tr
><tr id="gr_svn62_67"

><td id="67"><a href="#67">67</a></td></tr
><tr id="gr_svn62_68"

><td id="68"><a href="#68">68</a></td></tr
><tr id="gr_svn62_69"

><td id="69"><a href="#69">69</a></td></tr
><tr id="gr_svn62_70"

><td id="70"><a href="#70">70</a></td></tr
><tr id="gr_svn62_71"

><td id="71"><a href="#71">71</a></td></tr
><tr id="gr_svn62_72"

><td id="72"><a href="#72">72</a></td></tr
><tr id="gr_svn62_73"

><td id="73"><a href="#73">73</a></td></tr
><tr id="gr_svn62_74"

><td id="74"><a href="#74">74</a></td></tr
><tr id="gr_svn62_75"

><td id="75"><a href="#75">75</a></td></tr
><tr id="gr_svn62_76"

><td id="76"><a href="#76">76</a></td></tr
><tr id="gr_svn62_77"

><td id="77"><a href="#77">77</a></td></tr
><tr id="gr_svn62_78"

><td id="78"><a href="#78">78</a></td></tr
><tr id="gr_svn62_79"

><td id="79"><a href="#79">79</a></td></tr
><tr id="gr_svn62_80"

><td id="80"><a href="#80">80</a></td></tr
><tr id="gr_svn62_81"

><td id="81"><a href="#81">81</a></td></tr
><tr id="gr_svn62_82"

><td id="82"><a href="#82">82</a></td></tr
><tr id="gr_svn62_83"

><td id="83"><a href="#83">83</a></td></tr
><tr id="gr_svn62_84"

><td id="84"><a href="#84">84</a></td></tr
><tr id="gr_svn62_85"

><td id="85"><a href="#85">85</a></td></tr
><tr id="gr_svn62_86"

><td id="86"><a href="#86">86</a></td></tr
><tr id="gr_svn62_87"

><td id="87"><a href="#87">87</a></td></tr
><tr id="gr_svn62_88"

><td id="88"><a href="#88">88</a></td></tr
><tr id="gr_svn62_89"

><td id="89"><a href="#89">89</a></td></tr
><tr id="gr_svn62_90"

><td id="90"><a href="#90">90</a></td></tr
><tr id="gr_svn62_91"

><td id="91"><a href="#91">91</a></td></tr
><tr id="gr_svn62_92"

><td id="92"><a href="#92">92</a></td></tr
><tr id="gr_svn62_93"

><td id="93"><a href="#93">93</a></td></tr
><tr id="gr_svn62_94"

><td id="94"><a href="#94">94</a></td></tr
><tr id="gr_svn62_95"

><td id="95"><a href="#95">95</a></td></tr
><tr id="gr_svn62_96"

><td id="96"><a href="#96">96</a></td></tr
><tr id="gr_svn62_97"

><td id="97"><a href="#97">97</a></td></tr
><tr id="gr_svn62_98"

><td id="98"><a href="#98">98</a></td></tr
><tr id="gr_svn62_99"

><td id="99"><a href="#99">99</a></td></tr
><tr id="gr_svn62_100"

><td id="100"><a href="#100">100</a></td></tr
><tr id="gr_svn62_101"

><td id="101"><a href="#101">101</a></td></tr
><tr id="gr_svn62_102"

><td id="102"><a href="#102">102</a></td></tr
><tr id="gr_svn62_103"

><td id="103"><a href="#103">103</a></td></tr
><tr id="gr_svn62_104"

><td id="104"><a href="#104">104</a></td></tr
><tr id="gr_svn62_105"

><td id="105"><a href="#105">105</a></td></tr
><tr id="gr_svn62_106"

><td id="106"><a href="#106">106</a></td></tr
><tr id="gr_svn62_107"

><td id="107"><a href="#107">107</a></td></tr
><tr id="gr_svn62_108"

><td id="108"><a href="#108">108</a></td></tr
><tr id="gr_svn62_109"

><td id="109"><a href="#109">109</a></td></tr
><tr id="gr_svn62_110"

><td id="110"><a href="#110">110</a></td></tr
><tr id="gr_svn62_111"

><td id="111"><a href="#111">111</a></td></tr
><tr id="gr_svn62_112"

><td id="112"><a href="#112">112</a></td></tr
><tr id="gr_svn62_113"

><td id="113"><a href="#113">113</a></td></tr
><tr id="gr_svn62_114"

><td id="114"><a href="#114">114</a></td></tr
><tr id="gr_svn62_115"

><td id="115"><a href="#115">115</a></td></tr
><tr id="gr_svn62_116"

><td id="116"><a href="#116">116</a></td></tr
><tr id="gr_svn62_117"

><td id="117"><a href="#117">117</a></td></tr
><tr id="gr_svn62_118"

><td id="118"><a href="#118">118</a></td></tr
><tr id="gr_svn62_119"

><td id="119"><a href="#119">119</a></td></tr
><tr id="gr_svn62_120"

><td id="120"><a href="#120">120</a></td></tr
><tr id="gr_svn62_121"

><td id="121"><a href="#121">121</a></td></tr
><tr id="gr_svn62_122"

><td id="122"><a href="#122">122</a></td></tr
><tr id="gr_svn62_123"

><td id="123"><a href="#123">123</a></td></tr
><tr id="gr_svn62_124"

><td id="124"><a href="#124">124</a></td></tr
><tr id="gr_svn62_125"

><td id="125"><a href="#125">125</a></td></tr
><tr id="gr_svn62_126"

><td id="126"><a href="#126">126</a></td></tr
><tr id="gr_svn62_127"

><td id="127"><a href="#127">127</a></td></tr
><tr id="gr_svn62_128"

><td id="128"><a href="#128">128</a></td></tr
><tr id="gr_svn62_129"

><td id="129"><a href="#129">129</a></td></tr
><tr id="gr_svn62_130"

><td id="130"><a href="#130">130</a></td></tr
><tr id="gr_svn62_131"

><td id="131"><a href="#131">131</a></td></tr
><tr id="gr_svn62_132"

><td id="132"><a href="#132">132</a></td></tr
><tr id="gr_svn62_133"

><td id="133"><a href="#133">133</a></td></tr
><tr id="gr_svn62_134"

><td id="134"><a href="#134">134</a></td></tr
><tr id="gr_svn62_135"

><td id="135"><a href="#135">135</a></td></tr
><tr id="gr_svn62_136"

><td id="136"><a href="#136">136</a></td></tr
><tr id="gr_svn62_137"

><td id="137"><a href="#137">137</a></td></tr
><tr id="gr_svn62_138"

><td id="138"><a href="#138">138</a></td></tr
><tr id="gr_svn62_139"

><td id="139"><a href="#139">139</a></td></tr
><tr id="gr_svn62_140"

><td id="140"><a href="#140">140</a></td></tr
><tr id="gr_svn62_141"

><td id="141"><a href="#141">141</a></td></tr
><tr id="gr_svn62_142"

><td id="142"><a href="#142">142</a></td></tr
><tr id="gr_svn62_143"

><td id="143"><a href="#143">143</a></td></tr
><tr id="gr_svn62_144"

><td id="144"><a href="#144">144</a></td></tr
><tr id="gr_svn62_145"

><td id="145"><a href="#145">145</a></td></tr
><tr id="gr_svn62_146"

><td id="146"><a href="#146">146</a></td></tr
><tr id="gr_svn62_147"

><td id="147"><a href="#147">147</a></td></tr
><tr id="gr_svn62_148"

><td id="148"><a href="#148">148</a></td></tr
><tr id="gr_svn62_149"

><td id="149"><a href="#149">149</a></td></tr
><tr id="gr_svn62_150"

><td id="150"><a href="#150">150</a></td></tr
><tr id="gr_svn62_151"

><td id="151"><a href="#151">151</a></td></tr
><tr id="gr_svn62_152"

><td id="152"><a href="#152">152</a></td></tr
><tr id="gr_svn62_153"

><td id="153"><a href="#153">153</a></td></tr
><tr id="gr_svn62_154"

><td id="154"><a href="#154">154</a></td></tr
><tr id="gr_svn62_155"

><td id="155"><a href="#155">155</a></td></tr
><tr id="gr_svn62_156"

><td id="156"><a href="#156">156</a></td></tr
><tr id="gr_svn62_157"

><td id="157"><a href="#157">157</a></td></tr
><tr id="gr_svn62_158"

><td id="158"><a href="#158">158</a></td></tr
><tr id="gr_svn62_159"

><td id="159"><a href="#159">159</a></td></tr
></table></pre>
<pre><table width="100%"><tr class="nocursor"><td></td></tr></table></pre>
</td>
<td id="lines">
<pre><table width="100%"><tr class="cursor_stop cursor_hidden"><td></td></tr></table></pre>
<pre class="prettyprint lang-py"><table id="src_table_0"><tr
id=sl_svn62_1

><td class="source">#!/usr/bin/env python<br></td></tr
><tr
id=sl_svn62_2

><td class="source"><br></td></tr
><tr
id=sl_svn62_3

><td class="source"># Copyright 2007, Michael J. Harms<br></td></tr
><tr
id=sl_svn62_4

><td class="source"># This program is distributed under General Public License v. 3.  See the file<br></td></tr
><tr
id=sl_svn62_5

><td class="source"># COPYING for a copy of the license.  <br></td></tr
><tr
id=sl_svn62_6

><td class="source"><br></td></tr
><tr
id=sl_svn62_7

><td class="source">__description__ = \<br></td></tr
><tr
id=sl_svn62_8

><td class="source">&quot;&quot;&quot;<br></td></tr
><tr
id=sl_svn62_9

><td class="source">pdb_centermass.py<br></td></tr
><tr
id=sl_svn62_10

><td class="source"><br></td></tr
><tr
id=sl_svn62_11

><td class="source">Calculates the center of mass of a protein (assuming all atoms have equal mass).<br></td></tr
><tr
id=sl_svn62_12

><td class="source">Returns either the center or the recentered coordinates of the pdb (if coord <br></td></tr
><tr
id=sl_svn62_13

><td class="source">command line option is specified).<br></td></tr
><tr
id=sl_svn62_14

><td class="source">&quot;&quot;&quot;<br></td></tr
><tr
id=sl_svn62_15

><td class="source"><br></td></tr
><tr
id=sl_svn62_16

><td class="source">__author__ = &quot;Michael J. Harms&quot;<br></td></tr
><tr
id=sl_svn62_17

><td class="source">__date__ = &quot;061109&quot;<br></td></tr
><tr
id=sl_svn62_18

><td class="source"><br></td></tr
><tr
id=sl_svn62_19

><td class="source">import sys, re<br></td></tr
><tr
id=sl_svn62_20

><td class="source">from pdb_data import common<br></td></tr
><tr
id=sl_svn62_21

><td class="source"><br></td></tr
><tr
id=sl_svn62_22

><td class="source">def pdbCentermass(pdb,write_coord=False,include_hetatm=False,include_mass=True):<br></td></tr
><tr
id=sl_svn62_23

><td class="source">    &quot;&quot;&quot;<br></td></tr
><tr
id=sl_svn62_24

><td class="source">    Calculates center of mass assuming the same mass for all atoms.  Either <br></td></tr
><tr
id=sl_svn62_25

><td class="source">    returns recentered pdb or center of mass.<br></td></tr
><tr
id=sl_svn62_26

><td class="source">    &quot;&quot;&quot;<br></td></tr
><tr
id=sl_svn62_27

><td class="source"><br></td></tr
><tr
id=sl_svn62_28

><td class="source">    if include_hetatm:<br></td></tr
><tr
id=sl_svn62_29

><td class="source">        grab_lines = [&quot;ATOM  &quot;,&quot;HETATM&quot;]<br></td></tr
><tr
id=sl_svn62_30

><td class="source">    else:<br></td></tr
><tr
id=sl_svn62_31

><td class="source">        grab_lines = [&quot;ATOM  &quot;] <br></td></tr
><tr
id=sl_svn62_32

><td class="source"><br></td></tr
><tr
id=sl_svn62_33

><td class="source">    # Create a regular expression to strip out charge information from atom type<br></td></tr
><tr
id=sl_svn62_34

><td class="source">    # Look for any number or + or -<br></td></tr
><tr
id=sl_svn62_35

><td class="source">    charge_pattern = re.compile(&quot;[0-9]|\+|\-&quot;)<br></td></tr
><tr
id=sl_svn62_36

><td class="source"><br></td></tr
><tr
id=sl_svn62_37

><td class="source">    # Calculate the center of mass of the protein (assuming all atoms have the <br></td></tr
><tr
id=sl_svn62_38

><td class="source">    # same mass).<br></td></tr
><tr
id=sl_svn62_39

><td class="source">    warn = False<br></td></tr
><tr
id=sl_svn62_40

><td class="source">    coord = []<br></td></tr
><tr
id=sl_svn62_41

><td class="source">    masses = []<br></td></tr
><tr
id=sl_svn62_42

><td class="source">    for l in pdb:<br></td></tr
><tr
id=sl_svn62_43

><td class="source">        <br></td></tr
><tr
id=sl_svn62_44

><td class="source">        # Skip non ATOM/HETATM lines<br></td></tr
><tr
id=sl_svn62_45

><td class="source">        if l[0:6] not in grab_lines:<br></td></tr
><tr
id=sl_svn62_46

><td class="source">            continue<br></td></tr
><tr
id=sl_svn62_47

><td class="source"><br></td></tr
><tr
id=sl_svn62_48

><td class="source">        # Grab coordinates<br></td></tr
><tr
id=sl_svn62_49

><td class="source">        coord.append([float(l[30+i*8:38+i*8])for i in range(3)])<br></td></tr
><tr
id=sl_svn62_50

><td class="source"><br></td></tr
><tr
id=sl_svn62_51

><td class="source">        # If we&#39;re ignoring atom mass, record all masses as 1<br></td></tr
><tr
id=sl_svn62_52

><td class="source">        if not include_mass:<br></td></tr
><tr
id=sl_svn62_53

><td class="source">            masses.append(1.0)<br></td></tr
><tr
id=sl_svn62_54

><td class="source">            continue<br></td></tr
><tr
id=sl_svn62_55

><td class="source"><br></td></tr
><tr
id=sl_svn62_56

><td class="source">        # Otherwise, grab mass of each atom.  First try to grab atom type entry.<br></td></tr
><tr
id=sl_svn62_57

><td class="source">        # If it&#39;s missing, guess from the atom name column.<br></td></tr
><tr
id=sl_svn62_58

><td class="source">        atom_type = l[73:].strip()<br></td></tr
><tr
id=sl_svn62_59

><td class="source">        if atom_type == &quot;&quot;:<br></td></tr
><tr
id=sl_svn62_60

><td class="source"><br></td></tr
><tr
id=sl_svn62_61

><td class="source">            warn = True<br></td></tr
><tr
id=sl_svn62_62

><td class="source">            if l[12] == &quot; &quot;:<br></td></tr
><tr
id=sl_svn62_63

><td class="source">                atom_type = l[13]<br></td></tr
><tr
id=sl_svn62_64

><td class="source">            elif l[12] == &quot;H&quot;:<br></td></tr
><tr
id=sl_svn62_65

><td class="source">                atom_type = &quot;H&quot;<br></td></tr
><tr
id=sl_svn62_66

><td class="source">            else:<br></td></tr
><tr
id=sl_svn62_67

><td class="source">                atom_type = l[12:14].strip()<br></td></tr
><tr
id=sl_svn62_68

><td class="source"><br></td></tr
><tr
id=sl_svn62_69

><td class="source">        # Strip charge information from atom type<br></td></tr
><tr
id=sl_svn62_70

><td class="source">        atom_type = re.sub(charge_pattern,&quot;&quot;,atom_type)<br></td></tr
><tr
id=sl_svn62_71

><td class="source"><br></td></tr
><tr
id=sl_svn62_72

><td class="source">        # Now try to grab the mass <br></td></tr
><tr
id=sl_svn62_73

><td class="source">        try: <br></td></tr
><tr
id=sl_svn62_74

><td class="source">            masses.append(common.ATOM_WEIGHTS[atom_type])<br></td></tr
><tr
id=sl_svn62_75

><td class="source">        except:<br></td></tr
><tr
id=sl_svn62_76

><td class="source">            print &quot;File contains atoms of unknown type (%s)&quot; % atom_type<br></td></tr
><tr
id=sl_svn62_77

><td class="source">            print &quot;Will assign them mass of carbon (12.011 g/mol)&quot;<br></td></tr
><tr
id=sl_svn62_78

><td class="source">            print &quot;To fix, edit ATOM_WEIGHTS dictionary in pdb_data/common.py&quot;<br></td></tr
><tr
id=sl_svn62_79

><td class="source">            masses.append(12.011)<br></td></tr
><tr
id=sl_svn62_80

><td class="source"><br></td></tr
><tr
id=sl_svn62_81

><td class="source">    num_atoms = len(coord)<br></td></tr
><tr
id=sl_svn62_82

><td class="source">    <br></td></tr
><tr
id=sl_svn62_83

><td class="source">    total_mass = sum(masses)<br></td></tr
><tr
id=sl_svn62_84

><td class="source">    weights = [m/total_mass for m in masses] <br></td></tr
><tr
id=sl_svn62_85

><td class="source">    center = [sum([coord[i][j]*weights[i] for i in range(num_atoms)])<br></td></tr
><tr
id=sl_svn62_86

><td class="source">              for j in range(3)]<br></td></tr
><tr
id=sl_svn62_87

><td class="source"><br></td></tr
><tr
id=sl_svn62_88

><td class="source">    out = []<br></td></tr
><tr
id=sl_svn62_89

><td class="source">    # Re-center pdb file<br></td></tr
><tr
id=sl_svn62_90

><td class="source">    if write_coord:<br></td></tr
><tr
id=sl_svn62_91

><td class="source">        for line in pdb:<br></td></tr
><tr
id=sl_svn62_92

><td class="source">            if line[0:6] in [&quot;ATOM  &quot;,&quot;HETATM&quot;]:<br></td></tr
><tr
id=sl_svn62_93

><td class="source">                line_out = [line[0:30],0.,0.,0.,line[54:]]<br></td></tr
><tr
id=sl_svn62_94

><td class="source">                for i in range(3):<br></td></tr
><tr
id=sl_svn62_95

><td class="source">                    line_out[i+1] = float(line[30+i*8:38+i*8]) - center[i]<br></td></tr
><tr
id=sl_svn62_96

><td class="source">                out.append(&quot;%s%8.3F%8.3F%8.3F%s&quot; % tuple(line_out))<br></td></tr
><tr
id=sl_svn62_97

><td class="source">            else:<br></td></tr
><tr
id=sl_svn62_98

><td class="source">                out.append(line)<br></td></tr
><tr
id=sl_svn62_99

><td class="source"><br></td></tr
><tr
id=sl_svn62_100

><td class="source">    center_out = [&quot;%10.4F&quot; % c for c in center]<br></td></tr
><tr
id=sl_svn62_101

><td class="source"><br></td></tr
><tr
id=sl_svn62_102

><td class="source">    if warn:<br></td></tr
><tr
id=sl_svn62_103

><td class="source">        print &quot;Warning.  No element entries in file.  Attempting to extract&quot;<br></td></tr
><tr
id=sl_svn62_104

><td class="source">        print &quot;from the atom names.  Not always reliable...&quot;<br></td></tr
><tr
id=sl_svn62_105

><td class="source"><br></td></tr
><tr
id=sl_svn62_106

><td class="source">    return center_out, out<br></td></tr
><tr
id=sl_svn62_107

><td class="source"><br></td></tr
><tr
id=sl_svn62_108

><td class="source">def main():<br></td></tr
><tr
id=sl_svn62_109

><td class="source">    &quot;&quot;&quot;<br></td></tr
><tr
id=sl_svn62_110

><td class="source">    If called from command line...<br></td></tr
><tr
id=sl_svn62_111

><td class="source">    &quot;&quot;&quot;<br></td></tr
><tr
id=sl_svn62_112

><td class="source"><br></td></tr
><tr
id=sl_svn62_113

><td class="source">    from helper import cmdline<br></td></tr
><tr
id=sl_svn62_114

><td class="source"><br></td></tr
><tr
id=sl_svn62_115

><td class="source">    # Parse command line<br></td></tr
><tr
id=sl_svn62_116

><td class="source">    cmdline.initializeParser(__description__,__date__)<br></td></tr
><tr
id=sl_svn62_117

><td class="source">    cmdline.addOption(short_flag=&quot;c&quot;,<br></td></tr
><tr
id=sl_svn62_118

><td class="source">                      long_flag=&quot;coord&quot;,<br></td></tr
><tr
id=sl_svn62_119

><td class="source">                      action=&quot;store_true&quot;,<br></td></tr
><tr
id=sl_svn62_120

><td class="source">                      default=False,<br></td></tr
><tr
id=sl_svn62_121

><td class="source">                      help=&quot;write out re-centered coordinates&quot;)<br></td></tr
><tr
id=sl_svn62_122

><td class="source">    cmdline.addOption(short_flag=&quot;m&quot;,<br></td></tr
><tr
id=sl_svn62_123

><td class="source">                      long_flag=&quot;mass&quot;,<br></td></tr
><tr
id=sl_svn62_124

><td class="source">                      action=&quot;store_false&quot;,<br></td></tr
><tr
id=sl_svn62_125

><td class="source">                      default=True,<br></td></tr
><tr
id=sl_svn62_126

><td class="source">                      help=&quot;weight atoms by their mass&quot;)<br></td></tr
><tr
id=sl_svn62_127

><td class="source">    cmdline.addOption(short_flag=&quot;a&quot;,<br></td></tr
><tr
id=sl_svn62_128

><td class="source">                      long_flag=&quot;hetatm&quot;,<br></td></tr
><tr
id=sl_svn62_129

><td class="source">                      action=&quot;store_true&quot;,<br></td></tr
><tr
id=sl_svn62_130

><td class="source">                      default=False,<br></td></tr
><tr
id=sl_svn62_131

><td class="source">                      help=&quot;include hetatms in center of mass calc&quot;)<br></td></tr
><tr
id=sl_svn62_132

><td class="source">    <br></td></tr
><tr
id=sl_svn62_133

><td class="source"><br></td></tr
><tr
id=sl_svn62_134

><td class="source">    file_list, options = cmdline.parseCommandLine()<br></td></tr
><tr
id=sl_svn62_135

><td class="source">   <br></td></tr
><tr
id=sl_svn62_136

><td class="source">    for pdb_file in file_list:<br></td></tr
><tr
id=sl_svn62_137

><td class="source"><br></td></tr
><tr
id=sl_svn62_138

><td class="source">        # Load in pdb file<br></td></tr
><tr
id=sl_svn62_139

><td class="source">        f = open(pdb_file,&#39;r&#39;)<br></td></tr
><tr
id=sl_svn62_140

><td class="source">        pdb = f.readlines()<br></td></tr
><tr
id=sl_svn62_141

><td class="source">        f.close()<br></td></tr
><tr
id=sl_svn62_142

><td class="source"><br></td></tr
><tr
id=sl_svn62_143

><td class="source">        center, pdb_out = pdbCentermass(pdb,options.coord,options.hetatm,<br></td></tr
><tr
id=sl_svn62_144

><td class="source">                                        options.mass)<br></td></tr
><tr
id=sl_svn62_145

><td class="source">        print &quot;%s %s&quot; % (pdb_file,&quot;&quot;.join(center))<br></td></tr
><tr
id=sl_svn62_146

><td class="source"><br></td></tr
><tr
id=sl_svn62_147

><td class="source">        # If the user wants re-centered coordinates, write them out<br></td></tr
><tr
id=sl_svn62_148

><td class="source">        if options.coord:<br></td></tr
><tr
id=sl_svn62_149

><td class="source">            out_file = &quot;%s_center.pdb&quot; % pdb_file[:-4]<br></td></tr
><tr
id=sl_svn62_150

><td class="source">            g = open(out_file,&#39;w&#39;)<br></td></tr
><tr
id=sl_svn62_151

><td class="source">            g.writelines(pdb_out)<br></td></tr
><tr
id=sl_svn62_152

><td class="source">            g.close()<br></td></tr
><tr
id=sl_svn62_153

><td class="source"><br></td></tr
><tr
id=sl_svn62_154

><td class="source"><br></td></tr
><tr
id=sl_svn62_155

><td class="source"># If called from command line:<br></td></tr
><tr
id=sl_svn62_156

><td class="source">if __name__ == &quot;__main__&quot;:<br></td></tr
><tr
id=sl_svn62_157

><td class="source">    main()<br></td></tr
><tr
id=sl_svn62_158

><td class="source">    <br></td></tr
><tr
id=sl_svn62_159

><td class="source"><br></td></tr
></table></pre>
<pre><table width="100%"><tr class="cursor_stop cursor_hidden"><td></td></tr></table></pre>
</td>
</tr></table>

 
<script type="text/javascript">
 var lineNumUnderMouse = -1;
 
 function gutterOver(num) {
 gutterOut();
 var newTR = document.getElementById('gr_svn62_' + num);
 if (newTR) {
 newTR.className = 'undermouse';
 }
 lineNumUnderMouse = num;
 }
 function gutterOut() {
 if (lineNumUnderMouse != -1) {
 var oldTR = document.getElementById(
 'gr_svn62_' + lineNumUnderMouse);
 if (oldTR) {
 oldTR.className = '';
 }
 lineNumUnderMouse = -1;
 }
 }
 var numsGenState = {table_base_id: 'nums_table_'};
 var srcGenState = {table_base_id: 'src_table_'};
 var alignerRunning = false;
 var startOver = false;
 function setLineNumberHeights() {
 if (alignerRunning) {
 startOver = true;
 return;
 }
 numsGenState.chunk_id = 0;
 numsGenState.table = document.getElementById('nums_table_0');
 numsGenState.row_num = 0;
 if (!numsGenState.table) {
 return; // Silently exit if no file is present.
 }
 srcGenState.chunk_id = 0;
 srcGenState.table = document.getElementById('src_table_0');
 srcGenState.row_num = 0;
 alignerRunning = true;
 continueToSetLineNumberHeights();
 }
 function rowGenerator(genState) {
 if (genState.row_num < genState.table.rows.length) {
 var currentRow = genState.table.rows[genState.row_num];
 genState.row_num++;
 return currentRow;
 }
 var newTable = document.getElementById(
 genState.table_base_id + (genState.chunk_id + 1));
 if (newTable) {
 genState.chunk_id++;
 genState.row_num = 0;
 genState.table = newTable;
 return genState.table.rows[0];
 }
 return null;
 }
 var MAX_ROWS_PER_PASS = 1000;
 function continueToSetLineNumberHeights() {
 var rowsInThisPass = 0;
 var numRow = 1;
 var srcRow = 1;
 while (numRow && srcRow && rowsInThisPass < MAX_ROWS_PER_PASS) {
 numRow = rowGenerator(numsGenState);
 srcRow = rowGenerator(srcGenState);
 rowsInThisPass++;
 if (numRow && srcRow) {
 if (numRow.offsetHeight != srcRow.offsetHeight) {
 numRow.firstChild.style.height = srcRow.offsetHeight + 'px';
 }
 }
 }
 if (rowsInThisPass >= MAX_ROWS_PER_PASS) {
 setTimeout(continueToSetLineNumberHeights, 10);
 } else {
 alignerRunning = false;
 if (startOver) {
 startOver = false;
 setTimeout(setLineNumberHeights, 500);
 }
 }
 }
 function initLineNumberHeights() {
 // Do 2 complete passes, because there can be races
 // between this code and prettify.
 startOver = true;
 setTimeout(setLineNumberHeights, 250);
 window.onresize = setLineNumberHeights;
 }
 initLineNumberHeights();
</script>

 
 
 <div id="log">
 <div style="text-align:right">
 <a class="ifCollapse" href="#" onclick="_toggleMeta(this); return false">Show details</a>
 <a class="ifExpand" href="#" onclick="_toggleMeta(this); return false">Hide details</a>
 </div>
 <div class="ifExpand">
 
 
 <div class="pmeta_bubble_bg" style="border:1px solid white">
 <div class="round4"></div>
 <div class="round2"></div>
 <div class="round1"></div>
 <div class="box-inner">
 <div id="changelog">
 <p>Change log</p>
 <div>
 <a href="/p/pdb-tools/source/detail?spec=svn62&amp;r=62">r62</a>
 by harmsm
 on Dec 4, 2012
 &nbsp; <a href="/p/pdb-tools/source/diff?spec=svn62&r=62&amp;format=side&amp;path=/trunk/pdbTools/pdb_centermass.py&amp;old_path=/trunk/pdbTools/pdb_centermass.py&amp;old=56">Diff</a>
 </div>
 <pre>Two major modifications.  First,
pdb_residue-renumber.py is now a much
better,
more flexible script for altering residue
numbering.  Second, I altered
pdb_centermass.py so it now incorporates
mass information into the center of
mass calculation.
</pre>
 </div>
 
 
 
 
 
 
 <script type="text/javascript">
 var detail_url = '/p/pdb-tools/source/detail?r=62&spec=svn62';
 var publish_url = '/p/pdb-tools/source/detail?r=62&spec=svn62#publish';
 // describe the paths of this revision in javascript.
 var changed_paths = [];
 var changed_urls = [];
 
 changed_paths.push('/trunk/pdbTools/pdb_centermass.py');
 changed_urls.push('/p/pdb-tools/source/browse/trunk/pdbTools/pdb_centermass.py?r\x3d62\x26spec\x3dsvn62');
 
 var selected_path = '/trunk/pdbTools/pdb_centermass.py';
 
 
 changed_paths.push('/trunk/pdbTools/pdb_data/common.py');
 changed_urls.push('/p/pdb-tools/source/browse/trunk/pdbTools/pdb_data/common.py?r\x3d62\x26spec\x3dsvn62');
 
 
 changed_paths.push('/trunk/pdbTools/pdb_mutator.py');
 changed_urls.push('/p/pdb-tools/source/browse/trunk/pdbTools/pdb_mutator.py?r\x3d62\x26spec\x3dsvn62');
 
 
 changed_paths.push('/trunk/pdbTools/pdb_residue-renumber.py');
 changed_urls.push('/p/pdb-tools/source/browse/trunk/pdbTools/pdb_residue-renumber.py?r\x3d62\x26spec\x3dsvn62');
 
 
 function getCurrentPageIndex() {
 for (var i = 0; i < changed_paths.length; i++) {
 if (selected_path == changed_paths[i]) {
 return i;
 }
 }
 }
 function getNextPage() {
 var i = getCurrentPageIndex();
 if (i < changed_paths.length - 1) {
 return changed_urls[i + 1];
 }
 return null;
 }
 function getPreviousPage() {
 var i = getCurrentPageIndex();
 if (i > 0) {
 return changed_urls[i - 1];
 }
 return null;
 }
 function gotoNextPage() {
 var page = getNextPage();
 if (!page) {
 page = detail_url;
 }
 window.location = page;
 }
 function gotoPreviousPage() {
 var page = getPreviousPage();
 if (!page) {
 page = detail_url;
 }
 window.location = page;
 }
 function gotoDetailPage() {
 window.location = detail_url;
 }
 function gotoPublishPage() {
 window.location = publish_url;
 }
</script>

 
 <style type="text/css">
 #review_nav {
 border-top: 3px solid white;
 padding-top: 6px;
 margin-top: 1em;
 }
 #review_nav td {
 vertical-align: middle;
 }
 #review_nav select {
 margin: .5em 0;
 }
 </style>
 <div id="review_nav">
 <table><tr><td>Go to:&nbsp;</td><td>
 <select name="files_in_rev" onchange="window.location=this.value">
 
 <option value="/p/pdb-tools/source/browse/trunk/pdbTools/pdb_centermass.py?r=62&amp;spec=svn62"
 selected="selected"
 >/trunk/pdbTools/pdb_centermass.py</option>
 
 <option value="/p/pdb-tools/source/browse/trunk/pdbTools/pdb_data/common.py?r=62&amp;spec=svn62"
 
 >/trunk/pdbTools/pdb_data/common.py</option>
 
 <option value="/p/pdb-tools/source/browse/trunk/pdbTools/pdb_mutator.py?r=62&amp;spec=svn62"
 
 >/trunk/pdbTools/pdb_mutator.py</option>
 
 <option value="/p/pdb-tools/source/browse/trunk/pdbTools/pdb_residue-renumber.py?r=62&amp;spec=svn62"
 
 >...pdbTools/pdb_residue-renumber.py</option>
 
 </select>
 </td></tr></table>
 
 
 



 <div style="white-space:nowrap">
 Project members,
 <a href="https://www.google.com/accounts/ServiceLogin?service=code&amp;ltmpl=phosting&amp;continue=http%3A%2F%2Fcode.google.com%2Fp%2Fpdb-tools%2Fsource%2Fbrowse%2Ftrunk%2FpdbTools%2Fpdb_centermass.py&amp;followup=http%3A%2F%2Fcode.google.com%2Fp%2Fpdb-tools%2Fsource%2Fbrowse%2Ftrunk%2FpdbTools%2Fpdb_centermass.py"
 >sign in</a> to write a code review</div>


 
 </div>
 
 
 </div>
 <div class="round1"></div>
 <div class="round2"></div>
 <div class="round4"></div>
 </div>
 <div class="pmeta_bubble_bg" style="border:1px solid white">
 <div class="round4"></div>
 <div class="round2"></div>
 <div class="round1"></div>
 <div class="box-inner">
 <div id="older_bubble">
 <p>Older revisions</p>
 
 
 <div class="closed" style="margin-bottom:3px;" >
 <a class="ifClosed" onclick="return _toggleHidden(this)"><img src="http://www.gstatic.com/codesite/ph/images/plus.gif" ></a>
 <a class="ifOpened" onclick="return _toggleHidden(this)"><img src="http://www.gstatic.com/codesite/ph/images/minus.gif" ></a>
 <a href="/p/pdb-tools/source/detail?spec=svn62&r=56">r56</a>
 by harmsm
 on Nov 21, 2012
 &nbsp; <a href="/p/pdb-tools/source/diff?spec=svn62&r=56&amp;format=side&amp;path=/trunk/pdbTools/pdb_centermass.py&amp;old_path=/trunk/pdb_centermass.py&amp;old=28">Diff</a>
 <br>
 <pre class="ifOpened">Reorganize the source tree a bit.  Add
some code to find close contacts.

</pre>
 </div>
 
 
 
 <div class="closed" style="margin-bottom:3px;" >
 <a class="ifClosed" onclick="return _toggleHidden(this)"><img src="http://www.gstatic.com/codesite/ph/images/plus.gif" ></a>
 <a class="ifOpened" onclick="return _toggleHidden(this)"><img src="http://www.gstatic.com/codesite/ph/images/minus.gif" ></a>
 <a href="/p/pdb-tools/source/detail?spec=svn62&r=28">r28</a>
 by harmsm
 on Nov 26, 2008
 &nbsp; <a href="/p/pdb-tools/source/diff?spec=svn62&r=28&amp;format=side&amp;path=/trunk/pdb_centermass.py&amp;old_path=/pdb_centermass.py&amp;old=1">Diff</a>
 <br>
 <pre class="ifOpened">[No log message]</pre>
 </div>
 
 
 
 <div class="closed" style="margin-bottom:3px;" >
 <a class="ifClosed" onclick="return _toggleHidden(this)"><img src="http://www.gstatic.com/codesite/ph/images/plus.gif" ></a>
 <a class="ifOpened" onclick="return _toggleHidden(this)"><img src="http://www.gstatic.com/codesite/ph/images/minus.gif" ></a>
 <a href="/p/pdb-tools/source/detail?spec=svn62&r=1">r1</a>
 by harmsm
 on Apr 22, 2008
 &nbsp; <a href="/p/pdb-tools/source/diff?spec=svn62&r=1&amp;format=side&amp;path=/pdb_centermass.py&amp;old_path=/pdb_centermass.py&amp;old=">Diff</a>
 <br>
 <pre class="ifOpened">Initial source import</pre>
 </div>
 
 
 <a href="/p/pdb-tools/source/list?path=/trunk/pdbTools/pdb_centermass.py&start=62">All revisions of this file</a>
 </div>
 </div>
 <div class="round1"></div>
 <div class="round2"></div>
 <div class="round4"></div>
 </div>
 
 <div class="pmeta_bubble_bg" style="border:1px solid white">
 <div class="round4"></div>
 <div class="round2"></div>
 <div class="round1"></div>
 <div class="box-inner">
 <div id="fileinfo_bubble">
 <p>File info</p>
 
 <div>Size: 4820 bytes,
 159 lines</div>
 
 <div><a href="//pdb-tools.googlecode.com/svn/trunk/pdbTools/pdb_centermass.py">View raw file</a></div>
 </div>
 
 <div id="props">
 <p>File properties</p>
 <dl>
 
 <dt>svn:executable</dt>
 <dd></dd>
 
 </dl>
 </div>
 
 </div>
 <div class="round1"></div>
 <div class="round2"></div>
 <div class="round4"></div>
 </div>
 </div>
 </div>


</div>

</div>
</div>

<script src="http://www.gstatic.com/codesite/ph/10432160532581480325/js/prettify/prettify.js"></script>
<script type="text/javascript">prettyPrint();</script>


<script src="http://www.gstatic.com/codesite/ph/10432160532581480325/js/source_file_scripts.js"></script>

 <script type="text/javascript" src="http://www.gstatic.com/codesite/ph/10432160532581480325/js/kibbles.js"></script>
 <script type="text/javascript">
 var lastStop = null;
 var initialized = false;
 
 function updateCursor(next, prev) {
 if (prev && prev.element) {
 prev.element.className = 'cursor_stop cursor_hidden';
 }
 if (next && next.element) {
 next.element.className = 'cursor_stop cursor';
 lastStop = next.index;
 }
 }
 
 function pubRevealed(data) {
 updateCursorForCell(data.cellId, 'cursor_stop cursor_hidden');
 if (initialized) {
 reloadCursors();
 }
 }
 
 function draftRevealed(data) {
 updateCursorForCell(data.cellId, 'cursor_stop cursor_hidden');
 if (initialized) {
 reloadCursors();
 }
 }
 
 function draftDestroyed(data) {
 updateCursorForCell(data.cellId, 'nocursor');
 if (initialized) {
 reloadCursors();
 }
 }
 function reloadCursors() {
 kibbles.skipper.reset();
 loadCursors();
 if (lastStop != null) {
 kibbles.skipper.setCurrentStop(lastStop);
 }
 }
 // possibly the simplest way to insert any newly added comments
 // is to update the class of the corresponding cursor row,
 // then refresh the entire list of rows.
 function updateCursorForCell(cellId, className) {
 var cell = document.getElementById(cellId);
 // we have to go two rows back to find the cursor location
 var row = getPreviousElement(cell.parentNode);
 row.className = className;
 }
 // returns the previous element, ignores text nodes.
 function getPreviousElement(e) {
 var element = e.previousSibling;
 if (element.nodeType == 3) {
 element = element.previousSibling;
 }
 if (element && element.tagName) {
 return element;
 }
 }
 function loadCursors() {
 // register our elements with skipper
 var elements = CR_getElements('*', 'cursor_stop');
 var len = elements.length;
 for (var i = 0; i < len; i++) {
 var element = elements[i]; 
 element.className = 'cursor_stop cursor_hidden';
 kibbles.skipper.append(element);
 }
 }
 function toggleComments() {
 CR_toggleCommentDisplay();
 reloadCursors();
 }
 function keysOnLoadHandler() {
 // setup skipper
 kibbles.skipper.addStopListener(
 kibbles.skipper.LISTENER_TYPE.PRE, updateCursor);
 // Set the 'offset' option to return the middle of the client area
 // an option can be a static value, or a callback
 kibbles.skipper.setOption('padding_top', 50);
 // Set the 'offset' option to return the middle of the client area
 // an option can be a static value, or a callback
 kibbles.skipper.setOption('padding_bottom', 100);
 // Register our keys
 kibbles.skipper.addFwdKey("n");
 kibbles.skipper.addRevKey("p");
 kibbles.keys.addKeyPressListener(
 'u', function() { window.location = detail_url; });
 kibbles.keys.addKeyPressListener(
 'r', function() { window.location = detail_url + '#publish'; });
 
 kibbles.keys.addKeyPressListener('j', gotoNextPage);
 kibbles.keys.addKeyPressListener('k', gotoPreviousPage);
 
 
 }
 </script>
<script src="http://www.gstatic.com/codesite/ph/10432160532581480325/js/code_review_scripts.js"></script>
<script type="text/javascript">
 function showPublishInstructions() {
 var element = document.getElementById('review_instr');
 if (element) {
 element.className = 'opened';
 }
 }
 var codereviews;
 function revsOnLoadHandler() {
 // register our source container with the commenting code
 var paths = {'svn62': '/trunk/pdbTools/pdb_centermass.py'}
 codereviews = CR_controller.setup(
 {"assetVersionPath":"http://www.gstatic.com/codesite/ph/10432160532581480325","assetHostPath":"http://www.gstatic.com/codesite/ph","loggedInUserEmail":null,"relativeBaseUrl":"","projectName":"pdb-tools","domainName":null,"profileUrl":null,"token":null,"projectHomeUrl":"/p/pdb-tools"}, '', 'svn62', paths,
 CR_BrowseIntegrationFactory);
 
 codereviews.registerActivityListener(CR_ActivityType.REVEAL_DRAFT_PLATE, showPublishInstructions);
 
 codereviews.registerActivityListener(CR_ActivityType.REVEAL_PUB_PLATE, pubRevealed);
 codereviews.registerActivityListener(CR_ActivityType.REVEAL_DRAFT_PLATE, draftRevealed);
 codereviews.registerActivityListener(CR_ActivityType.DISCARD_DRAFT_COMMENT, draftDestroyed);
 
 
 
 
 
 
 
 var initialized = true;
 reloadCursors();
 }
 window.onload = function() {keysOnLoadHandler(); revsOnLoadHandler();};

</script>
<script type="text/javascript" src="http://www.gstatic.com/codesite/ph/10432160532581480325/js/dit_scripts.js"></script>

 
 
 
 <script type="text/javascript" src="http://www.gstatic.com/codesite/ph/10432160532581480325/js/ph_core.js"></script>
 
 
 
 
</div> 

<div id="footer" dir="ltr">
 <div class="text">
 <a href="/projecthosting/terms.html">Terms</a> -
 <a href="http://www.google.com/privacy.html">Privacy</a> -
 <a href="/p/support/">Project Hosting Help</a>
 </div>
</div>
 <div class="hostedBy" style="margin-top: -20px;">
 <span style="vertical-align: top;">Powered by <a href="http://code.google.com/projecthosting/">Google Project Hosting</a></span>
 </div>

 
 


 
 </body>
</html>

