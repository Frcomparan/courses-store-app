# frozen_string_literal: true

class LessonsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lesson, only: %i[show edit update destroy]
  before_action :set_course
  load_and_authorize_resource

  # GET /lessons or /lessons.json
  def index
    @lessons = Lesson.all
  end

  # GET /lessons/1 or /lessons/1.json
  def show
    @comment = @lesson.comments.new
  end

  # GET /lessons/new
  def new
    @lesson = @course.lessons.new
  end

  # GET /lessons/1/edit
  def edit; end

  # POST /lessons or /lessons.json
  def create
    @lesson = @course.lessons.new(lesson_params)
    respond_to do |format|
      if @lesson.save
        format.html { redirect_to course_lesson_url(@course, @lesson), notice: 'La clase fue creada exitosamente' }
        format.json { render :show, status: :created, location: @lesson }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lessons/1 or /lessons/1.json
  def update
    respond_to do |format|
      if @lesson.update(lesson_params)
        format.html { redirect_to course_lesson_url(@course, @lesson), notice: 'La clase de actualizo correctamente' }
        format.json { render :show, status: :ok, location: @lesson }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lesson.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lessons/1 or /lessons/1.json
  def destroy
    @course = @lesson.course
    @lesson.destroy
    if @course.lessons.size == 0
      @course.update(visibility: 0)
    end

    respond_to do |format|
      format.html { redirect_to course_url(@course), notice: 'La clase fue eliminada correctamente' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_lesson
    @lesson = Lesson.find(params[:id])
  end

  def set_course
    @course = Course.find(params[:course_id])
  end

  # Only allow a list of trusted parameters through.
  def lesson_params
    params.require(:lesson).permit(:title, :description, :lesson_number, :cover, :video, :course_id, extras: [])
  end
end
