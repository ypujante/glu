%{--
  - Copyright (c) 2010-2010 LinkedIn, Inc
  -
  - Licensed under the Apache License, Version 2.0 (the "License"); you may not
  - use this file except in compliance with the License. You may obtain a copy of
  - the License at
  -
  - http://www.apache.org/licenses/LICENSE-2.0
  -
  - Unless required by applicable law or agreed to in writing, software
  - distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
  - WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
  - License for the specific language governing permissions and limitations under
  - the License.
  --}%

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<g:set var="filters" value="[usernameFilter: 'Username', startTimeFilter: 'Start Time', endTimeFilter: 'End Time', durationFilter: 'Duration', statusFilter: 'Status', actionsFilter: 'Actions']"></g:set>
<head>
  <title>GLU Console - Deployments</title>
  <meta name="layout" content="main"/>
  <link rel="stylesheet" href="${resource(dir:'css',file:'status-colors.css')}"/>
  <style type="text/css">
    table {
      width: 100%;
    }
    table td {
      padding: 0.2em;
    }
    td {
      white-space: nowrap;
    }
    .progress {
      width: 150px;
      border: solid black 1px;
      display: inline-block;
    }
  </style>
  <script type="text/javascript" src="${resource(dir:'js',file:'console_yui.js')}"></script>
    <g:javascript>
function shouldRefresh()
{
  return document.getElementById('autoRefresh').checked;
}
function autoRefresh()
{
  if(shouldRefresh())
  {
    setTimeout('refresh()', ${params.refreshRate ?: '2000'});
    showElement('autoRefreshSpinner');
    showHide();
  }
  else
  {
    hideElement('autoRefreshSpinner');
  }
}
function refresh()
{
  if(shouldRefresh())
  {
    ${g.remoteFunction(controller: 'plan', action: 'renderDeployments', update:[success: 'asyncDetails', failure: 'asyncError'], onComplete: 'autoRefresh();')}
  }
  else
  {
    hideElement('autoRefreshSpinner');
  }
}
function showHide()
{
  <g:each in="${filters.keySet()}" var="filter">
    toggleClassChildren('asyncDetails', '${filter}', !document.getElementById('${filter}').checked, 'hidden');
  </g:each>
}
    </g:javascript>
</head>
<body onload="autoRefresh();">
<ul class="submenu">
  <li class="selected">Recent</li>
  <li><g:link action="archived">Archived</g:link></li>
</ul>
<g:if test="${groupBy != null}">
  <ul class="submenu">
    <li>Auto Refresh: <cl:checkBoxInitFromParams name="autoRefresh" id="autoRefresh" onclick="autoRefresh();"/>
      <img src="${resource(dir:'images',file:'spinner.gif')}" alt="Spinner" id="autoRefreshSpinner"/>
      <g:each in="${filters}" var="filter">
      |  ${filter.value}: <cl:checkBoxInitFromParams name="${filter.key}" id="${filter.key}" onclick="showHide();"/>
      </g:each>
    </li>
  </ul>
  <div id="asyncDetails">
    <g:render template="deployments" model="[groupBy: groupBy]"/>
  </div>
  <div id="asyncError"></div>
</g:if>
<g:else>
  <h2>No deployments...</h2>
</g:else>
</body>
</html>
