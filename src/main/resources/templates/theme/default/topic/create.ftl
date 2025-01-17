<#include "../layout/layout.ftl"/>
<@html page_title="创建话题" page_tab="">
    <div class="row">
        <div class="col-md-9">
            <div class="card">
                <div class="card-header">发布话题</div>
                <div class="card-body">
                    <form action="" onsubmit="return;" id="form">
                        <div class="form-group">
                            <label for="title">标题</label>
                            <input type="text" name="title" id="title" class="form-control" placeholder="标题"/>
                        </div>
                        <div class="form-group">
                            <label for="content">内容</label>
                            <span class="pull-right">
                <a href="javascript:uploadFile('topic')">上传图片</a>&nbsp;
                <a href="javascript:uploadFile('video')">上传视频</a>
              </span>
                            <textarea name="content" id="content" class="form-control"
                                      placeholder="内容，支持Markdown语法"></textarea>
                        </div>
                        <#--<div class="form-group">
                          <label for="tags">标签</label>
                          <input type="text" name="tags" id="tags" value="${tag!}" class="form-control"
                                 placeholder="标签, 多个标签以 英文逗号 隔开"/>
                        </div>-->
                        <input type="hidden" name="tag" id="tag" value="${tag!}"/>
                        <div class="form-group">
                            <button type="button" id="btn" class="btn btn-info">发布话题</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <div class="col-md-3 hidden-xs">
            <#include "../components/markdown_guide.ftl"/>
            <#include "../components/create_topic_guide.ftl"/>
        </div>
    </div>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.47.0/codemirror.min.css" rel="stylesheet">
    <script src="/static/theme/default/js/codemirror.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.47.0/mode/markdown/markdown.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.47.0/addon/display/placeholder.min.js"></script>
    <script>
        $(function () {
            CodeMirror.keyMap.default["Shift-Tab"] = "indentLess";
            CodeMirror.keyMap.default["Tab"] = "indentMore";
            window.editor = CodeMirror.fromTextArea(document.getElementById("content"), {
                lineNumbers: true,     // 显示行数
                indentUnit: 4,         // 缩进单位为4
                tabSize: 4,
                matchBrackets: true,   // 括号匹配
                mode: 'markdown',     // Markdown模式
                lineWrapping: true,    // 自动换行
            });
            window.editor.setSize('auto', '450px');

            $("#btn").click(function () {
                var title = $("#title").val();
                var tag = $("#tag").val();
                var content = window.editor.getDoc().getValue();
                // var tags = $("#tags").val();
                if (!title || title.length > 120) {
                    err("请输入标题，且最大长度在120个字符以内");
                    return;
                }
                // if (!tags || tags.split(",").length > 5) {
                //   err("请输入标签，且最多只能填5个");
                //   return;
                // }
                var _this = this;
                $(_this).button("loading");
                $.ajax({
                    url: '/api/topic',
                    cache: false,
                    async: false,
                    type: 'post',
                    dataType: 'json',
                    contentType: 'application/json',
                    headers: {
                        'token': '${_user.token}'
                    },
                    data: JSON.stringify({
                        title: title,
                        content: content,
                        tag: tag,
                        // tags: tags,
                    }),
                    success: function (data) {
                        if (data.code === 200) {
                            suc("创建成功");
                            setTimeout(function () {
                                window.location.href = "/topic/" + data.detail.id
                            }, 700);
                        } else {
                            err(data.description);
                            $(_this).button("reset");
                        }
                    }
                })
            });
        });
    </script>
    <#include "../components/upload.ftl"/>
</@html>
