from shiny import App, render, ui, reactive
from pathlib import Path

app_ui = ui.page_fluid(
ui.tags.img(src="www/HLA Logo_ALL BLACK.png", width="105px",
                                                            style="position: absolute; right: 0; height:60x; top: 0.5px;"),
    ui.input_text('textBox', "Enter text here", value=''),
    ui.input_action_button('runButton', 'Press me to print text!'),
    ui.output_text('text')
)


def server(input, output, session):

    @render.text
    @reactive.event(input.runButton)
    def text():
        return input.textBox()


app_dir = Path(__file__).parent
app = App(app_ui, server, static_assets=app_dir)