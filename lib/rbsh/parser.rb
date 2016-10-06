

module RBSH

  class Parser < RLTK::Parser

    # :input is not special; the first clause is
    # automatically the input clause.
    production(:input) do
      clause('pipeline_list')  {|e| AST::ClauseList.new(e) }
    end

    production(:pipeline_list) do
      clause('pipeline') {|e| [e]}
      clause('pipeline_list pipeline_separator pipeline') {|list,sep,e| list + sep + [e]}
    end

    production(:pipeline_separator) do
      clause('and')   {|s| [s]}
      clause('or')    {|s| [s]}
      clause('SEMI')  {|_| []}
    end

    production(:escaped, 'ESCAPED')       {|e| AST::Escaped.new(e) }
    production(:whitespace, 'WHITESPACE') {|s| AST::Whitespace.new(s) }
    production(:equals, 'EQUALS')         {|_| AST::Equals.new }
    production(:and, 'AND')               {|_| AST::And.new }
    production(:or, 'OR')                 {|_| AST::Or.new }


    production(:pipeline) do
      clause('pipeline_element_list') {|list| AST::Pipeline.new(list)}
    end
    production(:pipeline_element_list) do
      clause('') {|| []}
      clause('pipeline_element') {|e| [e]}
      clause('pipeline_element_list PIPE pipeline_element') {|list,_,e| list + [e]}
    end
    production(:pipeline_element) do
      clause('assignment_list empty_expression_list') {|a,e| AST::PipelineElement.new(a+e) }
    end

    production(:assignment_list) do
      clause('')                            {|| []}
      clause('assignment')                  {|a| [a]}
      clause('assignment_list assignment')  {|list,a| list + [a] }
      clause('assignment_list COMMA assignment')  {|list,_,a| list + [a] }
      clause('assignment_list SEMI assignment')   {|list,_,a| list + [a] }
    end

    production(:assignment) do
      clause('word equals special_expression') {|lhs,_,rhs| AST::Assignment.new(lhs, rhs) }
      clause('word equals word')               {|lhs,_,rhs| AST::Assignment.new(lhs, rhs) }
    end

    production(:word) do
      clause('WORD')        {|w| AST::Word.new(w) }
      clause('COMMA')       {|c| AST::Word.new(c) }
      # clause('SEMI')        {|s| AST::Word.new(s) }
    end


    production(:nonempty_expression_list) do
      clause('expression') {|e| [e]}
      clause('nonempty_expression_list expression') {|list,e| list + [e]}
    end

    production(:empty_expression_list) do
      clause('') { || [] }
      clause('nonempty_expression_list') {|list| list}
    end

    production(:expression) do
      clause('special_expression')    {|s| s}
      clause('nonspecial_expression') {|s| s}
    end

    production(:nonspecial_expression) do
      clause('word')                  {|s| s}
      clause('escaped')               {|s| s}
      clause('whitespace')            {|s| s}
      clause('equals')                {|s| s}
      # clause('and')                   {|s| s}
      # clause('or')                    {|s| s}
    end

    production(:special_expression) do
      clause('subshell')              {|s| s}
      clause('double_quoted_string')  {|s| s}
      clause('single_quoted_string')  {|s| s}
      clause('curly_braced')          {|s| s}
      clause('bracketed')             {|s| s}
      clause('parenthetical')         {|s| s}
    end


    production(:parenthetical) do
      clause('PAREN_START empty_expression_list PAREN_END') {|_,list,_| AST::Parenthetical.new(list) }
    end


    production(:subshell) do
      clause('SUBSHELL_START subshell_content SUBSHELL_END') {|_,list,_| AST::Subshell.new(list) }
    end
    production(:subshell_content) do
      clause('') { || [] }
      clause('subshell_element') {|e| [e]}
      clause('subshell_content subshell_element') { |list, e| list + [e] }
    end
    production(:subshell_element) do
      clause('expression')            {|s| s}
      clause('interpolation')         {|s| s}
    end


    production(:interpolation) do
      clause('INTERPOLATE_START interpolation_content INTERPOLATE_END') {|_,list,_| AST::Interpolation.new(list)}
    end
    production(:interpolation_content) do
      clause('empty_expression_list') {|list| list}
    end


    production(:single_quoted_string) do
      clause('SINGLE_QUOTE_START single_quote_content SINGLE_QUOTE_END') {|_,list,_| AST::SingleQuotedString.new(list)}
    end
    production(:single_quote_content) do
      clause('') {|| [] }
      clause('single_quote_element') {|e| [e]}
      clause('single_quote_content single_quote_element') {|list,e| list + [e]}
    end
    production(:single_quote_element) do
      clause('word')                {|s| s}
      clause('whitespace')          {|s| s}
      clause('escaped')              {|s| s}
    end


    production(:double_quoted_string) do
      clause('DOUBLE_QUOTE_START double_quote_content DOUBLE_QUOTE_END') {|_,list,_| AST::DoubleQuotedString.new(list)}
    end
    production(:double_quote_content) do
      clause('') {|| [] }
      clause('double_quote_element') {|e| [e]}
      clause('double_quote_content double_quote_element') {|list,e| list + [e]}
    end
    production(:double_quote_element) do
      clause('word')                {|s| s}
      clause('whitespace')          {|s| s}
      clause('escaped')              {|s| s}
      clause('interpolation')       {|s| s}
    end


    production(:curly_braced) do
      clause('CURLY_BRACE_START curly_brace_content CURLY_BRACE_END') {|_,list,_| AST::CurlyBraced.new(list)}
    end
    production(:curly_brace_content) do
      clause('') {|| [] }
      clause('curly_brace_element') {|e| [e]}
      clause('curly_brace_content curly_brace_element') {|list,e| list + [e]}
    end
    production(:curly_brace_element) do
      clause('word')                {|s| s}
      clause('whitespace')          {|s| s}
      clause('special_expression')  {|s| s}
    end


    production(:bracketed) do
      clause('BRACKET_START bracket_content BRACKET_END') {|_,list,_| AST::Bracketed.new(list)}
    end
    production(:bracket_content) do
      clause('') {|| [] }
      clause('bracket_element') {|e| [e]}
      clause('bracket_content bracket_element') {|list,e| list + [e]}
    end
    production(:bracket_element) do
      clause('word')                {|s| s}
      clause('whitespace')          {|s| s}
      clause('special_expression')  {|s| s}
    end

    finalize
    # finalize#(use: 'parser.tbl')
  end
end